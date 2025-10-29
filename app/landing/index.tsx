import { useState } from "react";
import { ScrollView, View } from "react-native";
import Hero from "../../components/Hero";

export default function Landing() {
  const [mode] = useState<"ranger" | "night">("ranger");
  return (
    <ScrollView style={{ backgroundColor: mode === "night" ? "#0f141a" : "#f7f8f3" }}>
      <View style={{ height: 8 }} />
      <Hero mode={mode} />
      <View style={{ paddingHorizontal: 24, paddingBottom: 64 }} />
    </ScrollView>
  );
}
