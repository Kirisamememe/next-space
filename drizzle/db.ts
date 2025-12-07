import "server-only";
import "dotenv/config";
import { drizzle } from "drizzle-orm/node-postgres";

/**
 * データベース
 */
export const db = drizzle(process.env.DATABASE_URL ?? "");
