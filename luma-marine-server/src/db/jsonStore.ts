import fs from "node:fs";
import path from "node:path";

/**
 * A tiny file-backed "database": one JSON array per entity, held in memory
 * and rewritten to disk on every mutation. Writes are serialized per-store
 * via a promise chain so concurrent requests can't interleave and corrupt
 * the file. Good enough for a low-traffic admin backend; swap for a real
 * database later without changing callers if this ever needs more scale.
 */
export class JsonStore<T extends { id: string }> {
  private readonly filePath: string;
  private cache: T[];
  private writeQueue: Promise<void> = Promise.resolve();

  /** True if this store's file didn't exist yet and was just created from `seed`. */
  readonly wasSeeded: boolean;

  constructor(dataDir: string, entityName: string, seed: T[] = []) {
    this.filePath = path.join(dataDir, `${entityName}.json`);
    fs.mkdirSync(dataDir, { recursive: true });
    this.wasSeeded = !fs.existsSync(this.filePath);
    if (this.wasSeeded) {
      fs.writeFileSync(this.filePath, JSON.stringify(seed, null, 2));
    }
    this.cache = JSON.parse(fs.readFileSync(this.filePath, "utf-8"));
  }

  all(): T[] {
    return this.cache;
  }

  find(predicate: (item: T) => boolean): T | undefined {
    return this.cache.find(predicate);
  }

  filter(predicate: (item: T) => boolean): T[] {
    return this.cache.filter(predicate);
  }

  getById(id: string): T | undefined {
    return this.cache.find((item) => item.id === id);
  }

  async insert(item: T): Promise<T> {
    this.cache.push(item);
    await this.persist();
    return item;
  }

  async update(id: string, patch: Partial<T>): Promise<T | undefined> {
    const index = this.cache.findIndex((item) => item.id === id);
    if (index === -1) return undefined;
    this.cache[index] = { ...this.cache[index], ...patch };
    await this.persist();
    return this.cache[index];
  }

  async replace(id: string, next: T): Promise<T | undefined> {
    const index = this.cache.findIndex((item) => item.id === id);
    if (index === -1) return undefined;
    this.cache[index] = next;
    await this.persist();
    return next;
  }

  async remove(id: string): Promise<boolean> {
    const before = this.cache.length;
    this.cache = this.cache.filter((item) => item.id !== id);
    if (this.cache.length === before) return false;
    await this.persist();
    return true;
  }

  private persist(): Promise<void> {
    this.writeQueue = this.writeQueue.then(
      () =>
        new Promise<void>((resolve, reject) => {
          fs.writeFile(
            this.filePath,
            JSON.stringify(this.cache, null, 2),
            (err) => (err ? reject(err) : resolve()),
          );
        }),
    );
    return this.writeQueue;
  }
}
