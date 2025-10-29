import React, { createContext, useContext, useMemo, useState } from 'react';
import { ThemeKey, THEMES } from '../themes';

type ThemeContextValue = {
  theme: ThemeKey;
  setTheme: (t: ThemeKey) => void;
  tokens: typeof THEMES[ThemeKey];
};

const ThemeContext = createContext<ThemeContextValue | undefined>(undefined);

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<ThemeKey>('ranger');
  const tokens = useMemo(() => THEMES[theme], [theme]);

  const value = useMemo(() => ({ theme, setTheme, tokens }), [theme, tokens]);
  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>;
}

export function useTheme() {
  const ctx = useContext(ThemeContext);
  if (!ctx) throw new Error('useTheme must be used within ThemeProvider');
  return ctx;
}
