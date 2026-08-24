export interface L10nText {
  sv: string;
  en: string;
  no: string;
  da: string;
}

export type ArticleCategory =
  | "ledStrips"
  | "navigation"
  | "deckInterior"
  | "controllers"
  | "kits";

export interface ArticleSpec {
  key: string;
  value: string;
  localizedValue?: L10nText;
}

export type StockMode = "stock" | "onDemand";

export interface Article {
  id: string;
  sku: string;
  supplierId: string;
  category: ArticleCategory;
  name: L10nText;
  shortDescription: L10nText;
  description: L10nText;
  specs: ArticleSpec[];
  priceSek: number;
  publiclyVisible: boolean;
  stockMode: StockMode;
  stockQuantity: number | null;
  discontinued: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface Supplier {
  id: string;
  name: string;
  address: string;
  contactPerson: string;
  orderMethod: string;
  leadTimeDays: number;
  active: boolean;
  removed: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface OrderCustomer {
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
}

export interface OrderShippingAddress {
  address: string;
  postalCode: string;
  city: string;
  country: string;
}

export interface OrderItem {
  articleId: string;
  sku: string;
  name: L10nText;
  supplierId: string;
  supplierName: string;
  quantity: number;
  unitPriceSek: number;
}

export type OrderStatus = "new" | "processing" | "shipped" | "cancelled";

export interface Order {
  id: string;
  orderNumber: string;
  customer: OrderCustomer;
  shippingAddress: OrderShippingAddress;
  comment: string | null;
  items: OrderItem[];
  subtotalSek: number;
  status: OrderStatus;
  createdAt: string;
}

export interface Banner {
  id: string;
  message: L10nText;
  startDate: string | null;
  endDate: string | null;
  active: boolean;
}

export interface Settings {
  contactEmail: string;
  contactPhone: string;
  openingHours: L10nText;
  banners: Banner[];
  updatedAt: string;
}

export interface AdminUser {
  id: string;
  email: string;
  passwordHash: string;
  name: string;
  active: boolean;
  createdAt: string;
}
