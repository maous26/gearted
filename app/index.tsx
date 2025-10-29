import { LinearGradient } from "expo-linear-gradient";
import { router } from "expo-router";
import React, { useState } from "react";
import {
  Dimensions,
  ScrollView,
  StatusBar,
  Text,
  TextInput,
  TouchableOpacity,
  View
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { BrandLogo } from "../components/BrandLogo";
import { CategoryPill } from "../components/CategoryPill";
import { FeatureCard } from "../components/FeatureCard";
import { CATEGORIES, FEATURE_CARDS, TRUST } from "../data";
import { THEMES, ThemeKey } from "../themes";

const { width } = Dimensions.get('window');

export default function GeartedLanding() {
  const [theme, setTheme] = useState<ThemeKey>("ranger");
  const [searchText, setSearchText] = useState("");
  const [location, setLocation] = useState("");
  
  const t = THEMES[theme];

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: t.rootBg }}>
      <StatusBar barStyle={theme === 'night' ? 'light-content' : 'dark-content'} />
      
      {/* Header */}
      <View style={{
        backgroundColor: t.navBg + 'CC',
        borderBottomWidth: 1,
        borderBottomColor: t.border,
        paddingHorizontal: 16,
        paddingVertical: 12,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center'
      }}>
        <BrandLogo theme={theme} size="small" showText={false} />
        <View style={{ flexDirection: 'row', gap: 8 }}>
          <TouchableOpacity 
            style={{
              backgroundColor: 'transparent',
              paddingHorizontal: 16,
              paddingVertical: 8,
              borderRadius: 12,
              borderWidth: 1,
              borderColor: t.primaryBtn
            }}
            onPress={() => router.push("/login" as any)}
          >
            <Text style={{ color: t.primaryBtn, fontWeight: '600' }}>Connexion</Text>
          </TouchableOpacity>
          <TouchableOpacity 
            style={{
              backgroundColor: t.primaryBtn,
              paddingHorizontal: 16,
              paddingVertical: 8,
              borderRadius: 12
            }}
            onPress={() => router.push("/register" as any)}
          >
            <Text style={{ color: t.white, fontWeight: '600' }}>S'inscrire</Text>
          </TouchableOpacity>
        </View>
      </View>

      <ScrollView style={{ flex: 1 }}>
        {/* Hero Section */}
        <LinearGradient
          colors={[t.heroGradStart + 'CC', t.heroGradEnd + '66']}
          style={{ paddingHorizontal: 16, paddingTop: 32, paddingBottom: 24 }}
        >
          <View>
            <Text style={{
              fontSize: 28,
              fontWeight: 'bold',
              color: t.heading,
              textAlign: 'center',
              marginBottom: 16
            }}>
              Vendez & échangez votre matériel{'\n'}
              <Text style={{ color: t.primaryBtn }}>airsoft</Text>
            </Text>
            
            {/* Featured Logo */}
            <View style={{ 
              alignItems: 'center', 
              marginBottom: 20,
              paddingVertical: 16
            }}>
              <BrandLogo theme={theme} size="large" showText={true} />
            </View>
            
            <Text style={{
              fontSize: 16,
              color: t.muted,
              lineHeight: 24,
              marginBottom: 16
            }}>
              Gearted, la marketplace dédiée aux répliques, pièces et gear. Achetez, vendez ou échangez avec paiement sécurisé (escrow), profils vérifiés et vérification de compatibilité.
            </Text>

            {/* Features List */}
            <View style={{ marginBottom: 24 }}>
              {[
                "Publication en 2 minutes",
                "Paiement sécurisé (escrow)", 
                "Profils vérifiés & avis",
                "Compatibilité technique"
              ].map((feature, index) => (
                <View key={index} style={{ 
                  flexDirection: 'row', 
                  alignItems: 'center', 
                  marginBottom: 8 
                }}>
                  <Text style={{ color: t.primaryBtn, marginRight: 8 }}>✓</Text>
                  <Text style={{ color: t.subtle, fontSize: 14 }}>{feature}</Text>
                </View>
              ))}
            </View>

            {/* Action Buttons */}
            <View style={{ 
              flexDirection: 'row', 
              flexWrap: 'wrap', 
              gap: 12, 
              marginBottom: 24 
            }}>
              <TouchableOpacity 
                style={{
                  backgroundColor: t.primaryBtn,
                  paddingHorizontal: 20,
                  paddingVertical: 12,
                  borderRadius: 12,
                  flexDirection: 'row',
                  alignItems: 'center'
                }}
                onPress={() => router.push("/register" as any)}
              >
                <Text style={{ color: t.white, fontWeight: '600', marginRight: 8 }}>+</Text>
                <Text style={{ color: t.white, fontWeight: '600' }}>Déposer une annonce</Text>
              </TouchableOpacity>
              
              <TouchableOpacity 
                style={{
                  borderWidth: 1,
                  borderColor: t.border,
                  backgroundColor: t.white,
                  paddingHorizontal: 20,
                  paddingVertical: 12,
                  borderRadius: 12
                }}
                onPress={() => router.push("/login" as any)}
              >
                <Text style={{ color: t.heading, fontWeight: '600' }}>Se connecter</Text>
              </TouchableOpacity>
            </View>

            {/* Search Section */}
            <View style={{ marginBottom: 24 }}>
              <View style={{
                backgroundColor: t.white,
                borderRadius: 12,
                borderWidth: 1,
                borderColor: t.border,
                padding: 12,
                marginBottom: 12
              }}>
                <Text style={{ color: t.muted, fontSize: 12, marginBottom: 8 }}>🔍 Rechercher</Text>
                <TextInput
                  placeholder="Rechercher un modèle, ex. M4, G17, VSR-10..."
                  value={searchText}
                  onChangeText={setSearchText}
                  style={{ 
                    fontSize: 16, 
                    color: t.heading,
                    paddingVertical: 4
                  }}
                  placeholderTextColor={t.extraMuted}
                />
              </View>
              
              <View style={{
                backgroundColor: t.white,
                borderRadius: 12,
                borderWidth: 1,
                borderColor: t.border,
                padding: 12,
                marginBottom: 12
              }}>
                <Text style={{ color: t.muted, fontSize: 12, marginBottom: 8 }}>📍 Localisation</Text>
                <TextInput
                  placeholder="Localisation (ex. Paris)"
                  value={location}
                  onChangeText={setLocation}
                  style={{ 
                    fontSize: 16, 
                    color: t.heading,
                    paddingVertical: 4
                  }}
                  placeholderTextColor={t.extraMuted}
                />
              </View>

              <TouchableOpacity style={{
                backgroundColor: t.primaryBtn,
                paddingVertical: 14,
                borderRadius: 12,
                alignItems: 'center'
              }}>
                <Text style={{ color: t.white, fontWeight: '600', fontSize: 16 }}>Chercher</Text>
              </TouchableOpacity>
            </View>

            {/* Trust Indicators */}
            <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 16 }}>
              {TRUST.map((item, index) => (
                <View key={index} style={{ 
                  flexDirection: 'row', 
                  alignItems: 'center' 
                }}>
                  <View style={{
                    width: 8,
                    height: 8,
                    borderRadius: 4,
                    backgroundColor: t.primaryBtn,
                    marginRight: 8
                  }} />
                  <Text style={{ color: t.muted, fontSize: 12 }}>{item.label}</Text>
                </View>
              ))}
            </View>
          </View>
        </LinearGradient>

        {/* Categories Section */}
        <View style={{ paddingHorizontal: 16, paddingVertical: 24 }}>
          <Text style={{
            fontSize: 20,
            fontWeight: 'bold',
            color: t.heading,
            marginBottom: 16
          }}>
            Parcourir par catégorie
          </Text>
          
          <View style={{ 
            flexDirection: 'row', 
            flexWrap: 'wrap', 
            gap: 12 
          }}>
            {CATEGORIES.map((category) => (
              <CategoryPill
                key={category.slug}
                label={category.label}
                icon={category.icon}
                theme={theme}
                onPress={() => console.log(`Pressed ${category.label}`)}
              />
            ))}
          </View>
        </View>

        {/* Features Section */}
        <View style={{ 
          backgroundColor: t.sectionLight + '66', 
          paddingHorizontal: 16, 
          paddingVertical: 24 
        }}>
          <Text style={{
            fontSize: 20,
            fontWeight: 'bold',
            color: t.heading,
            marginBottom: 16,
            textAlign: 'center'
          }}>
            Pourquoi choisir Gearted ?
          </Text>
          
          <View style={{ gap: 16 }}>
            {FEATURE_CARDS.map((feature, index) => (
              <FeatureCard
                key={index}
                title={feature.title}
                bullet={feature.bullet}
                icon={feature.icon}
                theme={theme}
              />
            ))}
          </View>
        </View>

        {/* Sample Listings */}
        <View style={{ 
          backgroundColor: t.sectionLight + '66', 
          paddingHorizontal: 16, 
          paddingVertical: 24 
        }}>
          <Text style={{
            fontSize: 20,
            fontWeight: 'bold',
            color: t.heading,
            marginBottom: 16
          }}>
            Annonces récentes
          </Text>
          
          <View style={{ 
            flexDirection: 'row', 
            flexWrap: 'wrap', 
            gap: 12 
          }}>
            {[1, 2, 3, 4].map((i) => (
              <View
                key={i}
                style={{
                  width: (width - 44) / 2,
                  backgroundColor: t.white,
                  borderRadius: 16,
                  padding: 12,
                  borderWidth: 1,
                  borderColor: t.border
                }}
              >
                <View style={{
                  height: 100,
                  backgroundColor: t.cardBg,
                  borderRadius: 12,
                  marginBottom: 12
                }} />
                <View style={{ 
                  flexDirection: 'row', 
                  justifyContent: 'space-between',
                  alignItems: 'center' 
                }}>
                  <View>
                    <Text style={{ 
                      fontSize: 14, 
                      fontWeight: '600', 
                      color: t.heading 
                    }}>
                      Annonce #{i}
                    </Text>
                    <Text style={{ 
                      fontSize: 12, 
                      color: t.extraMuted 
                    }}>
                      Très bon état
                    </Text>
                  </View>
                  <TouchableOpacity style={{
                    backgroundColor: t.pillBg,
                    paddingHorizontal: 12,
                    paddingVertical: 6,
                    borderRadius: 8
                  }}>
                    <Text style={{ 
                      fontSize: 12, 
                      color: t.heading,
                      fontWeight: '500' 
                    }}>
                      Voir
                    </Text>
                  </TouchableOpacity>
                </View>
              </View>
            ))}
          </View>
        </View>

        {/* Footer */}
        <View style={{
          backgroundColor: t.navBg + 'CC',
          borderTopWidth: 1,
          borderTopColor: t.border,
          paddingHorizontal: 16,
          paddingVertical: 32,
          alignItems: 'center'
        }}>
          <Text style={{
            fontSize: 24,
            fontWeight: 'bold',
            color: t.heading,
            marginBottom: 8
          }}>
            Gearted
          </Text>
          <Text style={{
            fontSize: 14,
            color: t.muted,
            textAlign: 'center'
          }}>
            Marketplace & échange de matériel airsoft{'\n'}
            sécurisé, simple, et pensé pour la communauté.
          </Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
