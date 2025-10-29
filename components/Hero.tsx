import { LinearGradient } from "expo-linear-gradient";
import { Alert, Pressable, Text, View } from "react-native";

export default function Hero({ mode = "ranger" }: { mode?: "ranger" | "night" }) {
  const isNight = mode === "night";
  return (
    <View style={{ paddingHorizontal: 24, paddingVertical: 40 }}>
      <LinearGradient
        colors={isNight ? ["#0f141a", "#181f28"] : ["#eef1e6", "#dbe1c4"]}
        start={{ x: 0, y: 0 }} end={{ x: 1, y: 1 }}
        style={{ borderRadius: 16, padding: 24 }}
      >
        <Text style={{ 
          color: isNight ? "white" : "#4e5d2f", 
          fontSize: 36, 
          fontWeight: "800" 
        }}>
          Gearted
        </Text>
        <Text style={{ 
          color: isNight ? "rgba(255,255,255,0.8)" : "rgba(78,93,47,0.8)", 
          marginTop: 12, 
          fontSize: 16 
        }}>
          Marketplace & échange de matériel airsoft — sécurisé, simple, et pensé pour la communauté.
        </Text>

        <View style={{ flexDirection: "row", gap: 12, marginTop: 24 }}>
          <Pressable 
            onPress={() => Alert.alert("Inscription","Redirection /signup (à venir)")}
            style={{ 
              backgroundColor: "#ffd166", 
              paddingHorizontal: 16, 
              paddingVertical: 12, 
              borderRadius: 12 
            }}
          >
            <Text style={{ fontWeight: "600" }}>Commencer maintenant</Text>
          </Pressable>
          <Pressable style={{ 
            paddingHorizontal: 16, 
            paddingVertical: 12, 
            borderRadius: 12,
            borderWidth: 1,
            borderColor: isNight ? "#344153" : "#62763a"
          }}>
            <Text style={{ color: isNight ? "white" : "#4e5d2f" }}>Voir le fonctionnement</Text>
          </Pressable>
        </View>
      </LinearGradient>
    </View>
  );
}
