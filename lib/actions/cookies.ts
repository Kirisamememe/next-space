"use server";

import { cookies } from "next/headers";

/**
 * クッキーを操作する
 */
export async function setCookie(name: string, value: string, maxAge?: number) {
  const cookieStore = await cookies();

  // Set cookie
  cookieStore.set(name, value, {
    maxAge,
  });
}

/**
 * クッキーを取得する
 */
export async function getCookie(name: string) {
  const cookieStore = await cookies();

  // Get cookie
  const cookie = cookieStore.get(name);
  return cookie?.value ?? null;
}

/**
 * クッキーを削除する
 */
export async function deleteCookie(name: string) {
  const cookieStore = await cookies();

  // Delete cookie
  cookieStore.delete(name);
}
