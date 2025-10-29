import { LinearGradient } from "expo-linear-gradient";
import { router } from "expo-router";
import React, { useState } from "react";
import {
    Alert,
    ScrollView,
    StatusBar,
    Text,
    TextInput,
    TouchableOpacity,
    View
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { THEMES, ThemeKey } from "../themes";

export default function RegisterScreen() {
  const [theme] = useState<ThemeKey>("ranger");
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  
  const t = THEMES[theme];

  const handleRegister = async () => {
    if (!firstName || !lastName || !username || !email || !password) {
      Alert.alert("Erreur", "Veuillez remplir tous les champs");
      return;
    }

    if (password !== confirmPassword) {
      Alert.alert("Erreur", "Les mots de passe ne correspondent pas");
      return;
    }

    if (password.length < 8) {
      Alert.alert("Erreur", "Le mot de passe doit contenir au moins 8 caractères");
      return;
    }

    setIsLoading(true);
    
    // For demo purposes, simulate successful registration
    setTimeout(() => {
      setIsLoading(false);
      Alert.alert(
        "Inscription réussie!", 
        "Votre compte a été créé avec succès en mode démo.",
        [
          {
            text: "Se connecter",
            onPress: () => router.push("/login" as any)
          }
        ]
      );
    }, 1000);
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: t.rootBg }}>
      <StatusBar barStyle={theme === 'night' ? 'light-content' : 'dark-content'} />
      
      <ScrollView style={{ flex: 1 }}>
        {/* Header */}
        <LinearGradient
          colors={[t.heroGradStart + 'CC', t.heroGradEnd + '66']}
          style={{ paddingHorizontal: 24, paddingTop: 60, paddingBottom: 40 }}
        >
          <Text style={{
            fontSize: 32,
            fontWeight: 'bold',
            color: t.heading,
            textAlign: 'center',
            marginBottom: 8
          }}>
            Inscription
          </Text>
          <Text style={{
            fontSize: 16,
            color: t.muted,
            textAlign: 'center'
          }}>
            Créez votre compte Gearted
          </Text>
        </LinearGradient>

        {/* Register Form */}
        <View style={{ paddingHorizontal: 24, paddingTop: 32 }}>
          <View style={{ flexDirection: 'row', gap: 12, marginBottom: 20 }}>
            <View style={{ flex: 1 }}>
              <Text style={{
                fontSize: 16,
                fontWeight: '600',
                color: t.heading,
                marginBottom: 8
              }}>
                Prénom
              </Text>
              <TextInput
                style={{
                  backgroundColor: t.cardBg,
                  borderRadius: 12,
                  paddingHorizontal: 16,
                  paddingVertical: 12,
                  fontSize: 16,
                  color: t.heading,
                  borderWidth: 1,
                  borderColor: t.border
                }}
                placeholder="John"
                value={firstName}
                onChangeText={setFirstName}
                placeholderTextColor={t.muted}
              />
            </View>

            <View style={{ flex: 1 }}>
              <Text style={{
                fontSize: 16,
                fontWeight: '600',
                color: t.heading,
                marginBottom: 8
              }}>
                Nom
              </Text>
              <TextInput
                style={{
                  backgroundColor: t.cardBg,
                  borderRadius: 12,
                  paddingHorizontal: 16,
                  paddingVertical: 12,
                  fontSize: 16,
                  color: t.heading,
                  borderWidth: 1,
                  borderColor: t.border
                }}
                placeholder="Doe"
                value={lastName}
                onChangeText={setLastName}
                placeholderTextColor={t.muted}
              />
            </View>
          </View>

          <View style={{ marginBottom: 20 }}>
            <Text style={{
              fontSize: 16,
              fontWeight: '600',
              color: t.heading,
              marginBottom: 8
            }}>
              Nom d'utilisateur
            </Text>
            <TextInput
              style={{
                backgroundColor: t.cardBg,
                borderRadius: 12,
                paddingHorizontal: 16,
                paddingVertical: 12,
                fontSize: 16,
                color: t.heading,
                borderWidth: 1,
                borderColor: t.border
              }}
              placeholder="johndoe"
              value={username}
              onChangeText={setUsername}
              placeholderTextColor={t.muted}
              autoCapitalize="none"
              autoCorrect={false}
            />
          </View>

          <View style={{ marginBottom: 20 }}>
            <Text style={{
              fontSize: 16,
              fontWeight: '600',
              color: t.heading,
              marginBottom: 8
            }}>
              Email
            </Text>
            <TextInput
              style={{
                backgroundColor: t.cardBg,
                borderRadius: 12,
                paddingHorizontal: 16,
                paddingVertical: 12,
                fontSize: 16,
                color: t.heading,
                borderWidth: 1,
                borderColor: t.border
              }}
              placeholder="votre.email@exemple.com"
              value={email}
              onChangeText={setEmail}
              placeholderTextColor={t.muted}
              keyboardType="email-address"
              autoCapitalize="none"
              autoCorrect={false}
            />
          </View>

          <View style={{ marginBottom: 20 }}>
            <Text style={{
              fontSize: 16,
              fontWeight: '600',
              color: t.heading,
              marginBottom: 8
            }}>
              Mot de passe
            </Text>
            <TextInput
              style={{
                backgroundColor: t.cardBg,
                borderRadius: 12,
                paddingHorizontal: 16,
                paddingVertical: 12,
                fontSize: 16,
                color: t.heading,
                borderWidth: 1,
                borderColor: t.border
              }}
              placeholder="••••••••"
              value={password}
              onChangeText={setPassword}
              placeholderTextColor={t.muted}
              secureTextEntry
            />
          </View>

          <View style={{ marginBottom: 32 }}>
            <Text style={{
              fontSize: 16,
              fontWeight: '600',
              color: t.heading,
              marginBottom: 8
            }}>
              Confirmer le mot de passe
            </Text>
            <TextInput
              style={{
                backgroundColor: t.cardBg,
                borderRadius: 12,
                paddingHorizontal: 16,
                paddingVertical: 12,
                fontSize: 16,
                color: t.heading,
                borderWidth: 1,
                borderColor: t.border
              }}
              placeholder="••••••••"
              value={confirmPassword}
              onChangeText={setConfirmPassword}
              placeholderTextColor={t.muted}
              secureTextEntry
            />
          </View>

          <TouchableOpacity
            style={{
              backgroundColor: t.primaryBtn,
              paddingVertical: 16,
              borderRadius: 12,
              alignItems: 'center',
              marginBottom: 16,
              opacity: isLoading ? 0.7 : 1
            }}
            onPress={handleRegister}
            disabled={isLoading}
          >
            <Text style={{
              color: t.white,
              fontSize: 16,
              fontWeight: '600'
            }}>
              {isLoading ? "Inscription..." : "S'inscrire"}
            </Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={{
              paddingVertical: 16,
              alignItems: 'center',
              marginBottom: 32
            }}
            onPress={() => router.push("/login" as any)}
          >
            <Text style={{
              color: t.muted,
              fontSize: 14
            }}>
              Déjà un compte ?{" "}
              <Text style={{ color: t.primaryBtn, fontWeight: '600' }}>
                Se connecter
              </Text>
            </Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}