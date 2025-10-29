import { Stack } from "expo-router";
import { useEffect, useState } from "react";
import { useColorScheme, View } from "react-native";

export default function RootLayout() {
  const system = useColorScheme();
  const [mode, setMode] = useState<"ranger" | "night">("ranger");
  useEffect(() => { if (system === "dark") setMode("night"); }, [system]);

  return (
    <View style={{ 
      backgroundColor: mode === "night" ? "#0f141a" : "#f7f8f3", 
      flex: 1 
    }}>
      <Stack screenOptions={{ headerShown: false }} />
    </View>
  );
}
