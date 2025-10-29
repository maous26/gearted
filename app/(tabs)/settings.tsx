import React, { useState } from "react";
import {
    ScrollView,
    StatusBar,
    Switch,
    Text,
    TouchableOpacity,
    View,
    Image,
    TextInput,
    Alert
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import * as ImagePicker from 'expo-image-picker';
import { useTheme } from "../../components/ThemeProvider";
import { useUser } from "../../components/UserProvider";
import { THEMES, ThemeKey } from "../../themes";

export default function Settings() {
  const { theme, setTheme } = useTheme();
  const { user, updateProfile } = useUser();
  const [notifications, setNotifications] = useState(true);
  const [darkMode, setDarkMode] = useState(false);
  const [isEditingProfile, setIsEditingProfile] = useState(false);
  const [editUsername, setEditUsername] = useState(user?.username || "");
  const [editTeamName, setEditTeamName] = useState(user?.teamName || "");
  
  const t = THEMES[theme];

  const selectAvatar = async () => {
    const permissionResult = await ImagePicker.requestMediaLibraryPermissionsAsync();
    if (!permissionResult.granted) {
      Alert.alert("Permission requise", "L'accès à la galerie est nécessaire");
      return;
    }

    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ['images'],
      allowsEditing: true,
      aspect: [1, 1],
      quality: 0.8,
    });

    if (!result.canceled && user) {
      updateProfile({ avatar: result.assets[0].uri });
    }
  };

  const saveProfile = () => {
    if (!editUsername.trim()) {
      Alert.alert("Erreur", "Le nom d'utilisateur ne peut pas être vide");
      return;
    }
    updateProfile({
      username: editUsername.trim(),
      teamName: editTeamName.trim() || "Sans équipe"
    });
    setIsEditingProfile(false);
  };

  const ProfileSection = () => (
    <View style={{
      backgroundColor: t.cardBg,
      borderRadius: 12,
      padding: 16,
      marginBottom: 24,
      borderWidth: 1,
      borderColor: t.border
    }}>
      <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
        <Text style={{
          fontSize: 18,
          fontWeight: 'bold',
          color: t.heading
        }}>
          Mon Profil
        </Text>
        <TouchableOpacity
          onPress={() => {
            if (isEditingProfile) {
              saveProfile();
            } else {
              setEditUsername(user?.username || "");
              setEditTeamName(user?.teamName || "");
              setIsEditingProfile(true);
            }
          }}
        >
          <Text style={{ fontSize: 14, color: t.primaryBtn, fontWeight: '600' }}>
            {isEditingProfile ? "Enregistrer" : "Modifier"}
          </Text>
        </TouchableOpacity>
      </View>

      {/* Avatar */}
      <View style={{ alignItems: 'center', marginBottom: 20 }}>
        <TouchableOpacity onPress={selectAvatar}>
          <View style={{
            width: 100,
            height: 100,
            borderRadius: 50,
            backgroundColor: t.border,
            justifyContent: 'center',
            alignItems: 'center',
            overflow: 'hidden',
            borderWidth: 3,
            borderColor: t.primaryBtn
          }}>
            {user?.avatar ? (
              <Image source={{ uri: user.avatar }} style={{ width: '100%', height: '100%' }} />
            ) : (
              <Text style={{ fontSize: 48 }}>👤</Text>
            )}
          </View>
          <View style={{
            position: 'absolute',
            bottom: 0,
            right: 0,
            backgroundColor: t.primaryBtn,
            borderRadius: 15,
            width: 30,
            height: 30,
            justifyContent: 'center',
            alignItems: 'center'
          }}>
            <Text style={{ fontSize: 16 }}>📷</Text>
          </View>
        </TouchableOpacity>
      </View>

      {/* Username */}
      <View style={{ marginBottom: 16 }}>
        <Text style={{ fontSize: 14, color: t.muted, marginBottom: 4 }}>
          Nom d'utilisateur
        </Text>
        {isEditingProfile ? (
          <TextInput
            style={{
              backgroundColor: t.rootBg,
              borderRadius: 8,
              padding: 12,
              fontSize: 16,
              color: t.heading,
              borderWidth: 1,
              borderColor: t.border
            }}
            value={editUsername}
            onChangeText={setEditUsername}
            placeholder="Votre pseudo"
            placeholderTextColor={t.muted}
            maxLength={20}
          />
        ) : (
          <Text style={{ fontSize: 16, color: t.heading, fontWeight: '600' }}>
            {user?.username || "Non défini"}
          </Text>
        )}
      </View>

      {/* Team Name */}
      <View>
        <Text style={{ fontSize: 14, color: t.muted, marginBottom: 4 }}>
          Équipe
        </Text>
        {isEditingProfile ? (
          <TextInput
            style={{
              backgroundColor: t.rootBg,
              borderRadius: 8,
              padding: 12,
              fontSize: 16,
              color: t.heading,
              borderWidth: 1,
              borderColor: t.border
            }}
            value={editTeamName}
            onChangeText={setEditTeamName}
            placeholder="Nom de votre équipe"
            placeholderTextColor={t.muted}
            maxLength={30}
          />
        ) : (
          <Text style={{ fontSize: 16, color: t.heading }}>
            {user?.teamName || "Sans équipe"}
          </Text>
        )}
      </View>

      {isEditingProfile && (
        <TouchableOpacity
          onPress={() => {
            setIsEditingProfile(false);
            setEditUsername(user?.username || "");
            setEditTeamName(user?.teamName || "");
          }}
          style={{ marginTop: 12, alignItems: 'center' }}
        >
          <Text style={{ fontSize: 14, color: t.muted }}>Annuler</Text>
        </TouchableOpacity>
      )}
    </View>
  );

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
        {/* Profile Section */}
        <ProfileSection />

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