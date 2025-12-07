import { useTranslations } from "next-intl";

/**
 * Home page
 */
const HomePage: React.FC = () => {
  const t = useTranslations();

  return (
    <div className="flex min-h-screen items-center justify-center bg-zinc-50 font-sans dark:bg-black">
      <main className="flex min-h-screen w-full max-w-3xl flex-col items-center justify-between py-32 px-16 bg-white dark:bg-black sm:items-start">
        <h1>{t("dashboard.welcome", { name: "John Doe" })}</h1>
      </main>
    </div>
  );
};

export default HomePage;
