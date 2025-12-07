import { toNextJsHandler } from "better-auth/next-js";
import { auth } from "@/lib/auth";

/**
 * Auth API
 */
export const { POST, GET } = toNextJsHandler(auth);
