import { cookies } from "next/headers";
import { getRequestConfig } from "next-intl/server";
import { COOKIE_NAME } from "@/constants";
import { DEFAULT_LOCALE } from "@/i18n/locale";

/**
 * Get Request Config
 */
export default getRequestConfig(async () => {
  const store = await cookies();
  const locale = store.get(COOKIE_NAME.LOCALE)?.value ?? DEFAULT_LOCALE;

  return {
    locale,
    messages: (await import(`@/i18n/messages/${locale}.json`)).default,
  };
});
