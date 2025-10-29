import React, { useState } from "react";
import {
    ScrollView,
    StatusBar,
    Switch,
    Text,
    TouchableOpacity,
    View
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { THEMES, ThemeKey } from "../../themes";

export default function Settings() {
  const [theme, setTheme] = useState<ThemeKey>("ranger");
  const [notifications, setNotifications] = useState(true);
  const [darkMode, setDarkMode] = useState(false);
  
  const t = THEMES[theme];

  const ThemeSelector = () => (
    <View style={{ marginTop: 16 }}>
      <Text style={{ 
        fontSize: 16, 
        fontWeight: '600', 
        color: t.heading,
        marginBottom: 12 
      }}>
        Thème de l'application
      </Text>
      <View style={{ 
        flexDirection: 'row', 
        backgroundColor: t.cardBg, 
        borderRadius: 12, 
        padding: 4,
        borderWidth: 1,
        borderColor: t.border
      }}>
        {(['ranger', 'desert', 'night'] as ThemeKey[]).map((themeKey) => (
          <TouchableOpacity
            key={themeKey}
            onPress={() => setTheme(themeKey)}
            style={{
              flex: 1,
              paddingHorizontal: 12,
              paddingVertical: 8,
              borderRadius: 8,
              backgroundColor: theme === themeKey ? t.primaryBtn : 'transparent'
            }}
          >
            <Text style={{ 
              fontSize: 14, 
              color: theme === themeKey ? t.white : t.muted,
              textAlign: 'center',
              textTransform: 'capitalize',
              fontWeight: theme === themeKey ? '600' : '400'
            }}>
              {themeKey === 'night' ? 'Night Ops' : themeKey}
            </Text>
          </TouchableOpacity>
        ))}
      </View>
    </View>
  );

  const SettingRow = ({ 
    title, 
    subtitle, 
    value, 
    onValueChange 
  }: { 
    title: string; 
    subtitle?: string; 
    value: boolean; 
    onValueChange: (value: boolean) => void; 
  }) => (
    <View style={{
      flexDirection: 'row',
      justifyContent: 'space-between',
      alignItems: 'center',
      paddingVertical: 16,
      paddingHorizontal: 16,
      backgroundColor: t.cardBg,
      borderRadius: 12,
      marginBottom: 8,
      borderWidth: 1,
      borderColor: t.border
    }}>
      <View style={{ flex: 1 }}>
        <Text style={{ fontSize: 16, fontWeight: '600', color: t.heading }}>
          {title}
        </Text>
        {subtitle && (
          <Text style={{ fontSize: 14, color: t.muted, marginTop: 2 }}>
            {subtitle}
          </Text>
        )}
      </View>
      <Switch
        value={value}
        onValueChange={onValueChange}
        trackColor={{ false: t.border, true: t.primaryBtn + '80' }}
        thumbColor={value ? t.primaryBtn : t.cardBg}
      />
    </View>
  );

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: t.rootBg }}>
      <StatusBar barStyle={theme === 'night' ? 'light-content' : 'dark-content'} />
      
      {/* Header */}
      <View style={{
        backgroundColor: t.navBg + 'CC',
        borderBottomWidth: 1,
        borderBottomColor: t.border,
        paddingHorizontal: 16,
        paddingVertical: 16
      }}>
        <Text style={{
          fontSize: 24,
          fontWeight: 'bold',
          color: t.heading,
          textAlign: 'center'
        }}>
          Paramètres
        </Text>
      </View>

      <ScrollView style={{ flex: 1, paddingHorizontal: 16, paddingTop: 16 }}>
        {/* Theme Selector */}
        <ThemeSelector />

        {/* Settings Options */}
        <View style={{ marginTop: 32 }}>
          <Text style={{ 
            fontSize: 18, 
            fontWeight: '700', 
            color: t.heading,
            marginBottom: 16 
          }}>
            Préférences
          </Text>
          
          <SettingRow
            title="Notifications"
            subtitle="Recevoir des notifications pour les nouveaux messages et offres"
            value={notifications}
            onValueChange={setNotifications}
          />
          
          <SettingRow
            title="Mode sombre automatique"
            subtitle="Basculer automatiquement selon l'heure du système"
            value={darkMode}
            onValueChange={setDarkMode}
          />
        </View>

        {/* Account Section */}
        <View style={{ marginTop: 32 }}>
          <Text style={{ 
            fontSize: 18, 
            fontWeight: '700', 
            color: t.heading,
            marginBottom: 16 
          }}>
            Compte
          </Text>
          
          <TouchableOpacity style={{
            paddingVertical: 16,
            paddingHorizontal: 16,
            backgroundColor: t.cardBg,
            borderRadius: 12,
            marginBottom: 8,
            borderWidth: 1,
            borderColor: t.border
          }}>
            <Text style={{ fontSize: 16, fontWeight: '600', color: t.heading }}>
              Profil utilisateur
            </Text>
            <Text style={{ fontSize: 14, color: t.muted, marginTop: 2 }}>
              Modifier vos informations personnelles
            </Text>
          </TouchableOpacity>

          <TouchableOpacity style={{
            paddingVertical: 16,
            paddingHorizontal: 16,
            backgroundColor: t.cardBg,
            borderRadius: 12,
            marginBottom: 8,
            borderWidth: 1,
            borderColor: t.border
          }}>
            <Text style={{ fontSize: 16, fontWeight: '600', color: t.heading }}>
              Sécurité
            </Text>
            <Text style={{ fontSize: 14, color: t.muted, marginTop: 2 }}>
              Modifier votre mot de passe et paramètres de sécurité
            </Text>
          </TouchableOpacity>
        </View>

        {/* Logout */}
        <TouchableOpacity style={{
          marginTop: 32,
          marginBottom: 32,
          paddingVertical: 16,
          paddingHorizontal: 16,
          backgroundColor: '#ff4757',
          borderRadius: 12,
          alignItems: 'center'
        }}>
          <Text style={{ fontSize: 16, fontWeight: '600', color: 'white' }}>
            Se déconnecter
          </Text>
        </TouchableOpacity>
      </ScrollView>
    </SafeAreaView>
  );
}