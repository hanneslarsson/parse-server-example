import fs from "node:fs";
import path from "node:path";

/** Same idea as JsonStore, but for a single JSON object rather than an array. */
export class SingletonStore<T> {
  private readonly filePath: string;
  private cache: T;
  private writeQueue: Promise<void> = Promise.resolve();

  constructor(dataDir: string, entityName: string, seed: T) {
    this.filePath = path.join(dataDir, `${entityName}.json`);
    fs.mkdirSync(dataDir, { recursive: true });
    if (!fs.existsSync(this.filePath)) {
      fs.writeFileSync(this.filePath, JSON.stringify(seed, null, 2));
    }
    this.cache = JSON.parse(fs.readFileSync(this.filePath, "utf-8"));
  }

  get(): T {
    return this.cache;
  }

  async set(next: T): Promise<T> {
    this.cache = next;
    await this.persist();
    return this.cache;
  }

  async patch(patch: Partial<T>): Promise<T> {
    this.cache = { ...this.cache, ...patch };
    await this.persist();
    return this.cache;
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
