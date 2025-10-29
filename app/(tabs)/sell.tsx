import * as ImagePicker from 'expo-image-picker';
import { router } from "expo-router";
import React, { useState } from "react";
import {
    Alert,
    Dimensions,
    Image,
    ScrollView,
    StatusBar,
    Text,
    TextInput,
    TouchableOpacity,
    View
} from "react-native";
import { KeyboardAwareScrollView } from "react-native-keyboard-aware-scroll-view";
import { SafeAreaView } from "react-native-safe-area-context";
import { useTheme } from "../../components/ThemeProvider";
import { CATEGORIES } from "../../data/index";
import { THEMES } from "../../themes";
type ThemeTokens = typeof THEMES["ranger"];

// Stable components (defined outside SellScreen) to prevent remounts on keystroke
function TypeTabButton({
  t,
  type,
  label,
  currentType,
  onPress,
}: {
  t: ThemeTokens;
  type: "sell" | "exchange";
  label: string;
  currentType: "sell" | "exchange";
  onPress: () => void;
}) {
  return (
    <TouchableOpacity
      style={{
        flex: 1,
        paddingVertical: 12,
        backgroundColor: currentType === type ? t.primaryBtn : t.cardBg,
        borderRadius: 8,
        alignItems: 'center',
        borderWidth: 1,
        borderColor: currentType === type ? t.primaryBtn : t.border
      }}
      onPress={onPress}
    >
      <Text style={{
        color: currentType === type ? t.white : t.heading,
        fontWeight: '600',
      }}>
        {label}
      </Text>
    </TouchableOpacity>
  );
}

function FormInputField({ 
  t,
  label, 
  value, 
  onChangeText, 
  placeholder, 
  multiline = false,
  keyboardType = "default" as any
}: {
  t: ThemeTokens;
  label: string;
  value: string;
  onChangeText: (text: string) => void;
  placeholder: string;
  multiline?: boolean;
  keyboardType?: any;
}) {
  return (
    <View style={{ marginBottom: 16 }}>
      <Text style={{
        fontSize: 16,
        fontWeight: '600',
        color: t.heading,
        marginBottom: 8
      }}>
        {label} <Text style={{ color: '#FF6B6B' }}>*</Text>
      </Text>
      <TextInput
        style={{
          backgroundColor: t.cardBg,
          borderRadius: 8,
          paddingHorizontal: 16,
          paddingVertical: 12,
          borderWidth: 1,
          borderColor: t.border,
          fontSize: 16,
          color: t.heading,
          minHeight: multiline ? 100 : 50,
          textAlignVertical: multiline ? 'top' : 'center'
        }}
        value={value}
        onChangeText={onChangeText}
        placeholder={placeholder}
        placeholderTextColor={t.muted}
        multiline={multiline}
        keyboardType={keyboardType}
        blurOnSubmit={false}
        returnKeyType={multiline ? "default" : "next"}
        autoCorrect={false}
        autoCapitalize="sentences"
      />
    </View>
  );
}

function FormSelectField({ 
  t,
  label, 
  value, 
  options, 
  onSelect, 
  placeholder 
}: {
  t: ThemeTokens;
  label: string;
  value: string;
  options: { label: string; value: string }[];
  onSelect: (value: string) => void;
  placeholder: string;
}) {
  return (
    <View style={{ marginBottom: 16 }}>
      <Text style={{
        fontSize: 16,
        fontWeight: '600',
        color: t.heading,
        marginBottom: 8
      }}>
        {label} <Text style={{ color: '#FF6B6B' }}>*</Text>
      </Text>
      <ScrollView 
        horizontal 
        showsHorizontalScrollIndicator={false}
        keyboardShouldPersistTaps="handled"
      >
        <View style={{ flexDirection: 'row', gap: 8, paddingBottom: 4 }}>
          {options.map((option) => (
            <TouchableOpacity
              key={option.value}
              style={{
                paddingHorizontal: 16,
                paddingVertical: 8,
                borderRadius: 20,
                backgroundColor: value === option.value ? t.primaryBtn : t.cardBg,
                borderWidth: 1,
                borderColor: value === option.value ? t.primaryBtn : t.border
              }}
              onPress={() => onSelect(option.value)}
            >
              <Text style={{
                color: value === option.value ? t.white : t.heading,
                fontWeight: '500',
                fontSize: 14
              }}>
                {option.label}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </ScrollView>
    </View>
  );
}

const CONDITIONS = [
  "Neuf",
  "Excellent", 
  "Très bon",
  "Bon",
  "Correct",
  "Pièces"
];

const BRANDS = [
  "Tokyo Marui",
  "G&G",
  "VFC",
  "WE Tech",
  "KWA",
  "Krytac", 
  "ASG",
  "Cyma",
  "LCT",
  "E&L",
  "APS",
  "Ares",
  "Classic Army",
  "ICS",
  "Marui",
  "Other"
];

const { width } = Dimensions.get('window');

type ListingType = "sell" | "exchange";

export default function SellScreen() {
  const { theme } = useTheme();
  const [listingType, setListingType] = useState<ListingType>("sell");
  
  // Form state
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [price, setPrice] = useState("");
  const [category, setCategory] = useState("");
  const [condition, setCondition] = useState("");
  const [brand, setBrand] = useState("");
  const [images, setImages] = useState<string[]>([]);
  
  // Exchange specific
  const [wantedItems, setWantedItems] = useState("");
  const [exchangeValue, setExchangeValue] = useState("");
  
  const t = THEMES[theme];

  const handleSubmit = () => {
    if (!title || !description || !category || !condition) {
      Alert.alert("Erreur", "Veuillez remplir tous les champs obligatoires");
      return;
    }

    if (listingType === "sell" && !price) {
      Alert.alert("Erreur", "Veuillez indiquer un prix pour la vente");
      return;
    }

    if (listingType === "exchange" && !wantedItems) {
      Alert.alert("Erreur", "Veuillez indiquer ce que vous recherchez en échange");
      return;
    }

    // Simulate posting
    Alert.alert(
      "Succès", 
      listingType === "sell" 
        ? "Votre annonce de vente a été publiée !" 
        : "Votre annonce d'échange a été publiée !",
      [{ text: "OK", onPress: () => router.back() }]
    );
  };

  const pickImage = async () => {
    try {
      // Demander permission pour accéder à la galerie
      const permissionResult = await ImagePicker.requestMediaLibraryPermissionsAsync();
      
      if (permissionResult.granted === false) {
        Alert.alert("Permission requise", "Veuillez autoriser l'accès à vos photos pour ajouter des images");
        return;
      }

      // Afficher les options de sélection
      Alert.alert(
        "Ajouter une photo",
        "Choisissez une option",
        [
          {
            text: "Galerie",
            onPress: () => selectFromGallery()
          },
          {
            text: "Appareil photo",
            onPress: () => takePicture()
          },
          {
            text: "Annuler",
            style: "cancel"
          }
        ]
      );
    } catch (error) {
      Alert.alert("Erreur", "Impossible d'accéder aux photos");
    }
  };

    const selectFromGallery = async () => {
    try {
      const result = await ImagePicker.launchImageLibraryAsync({
        mediaTypes: ['images'],
        allowsEditing: true,
        aspect: [4, 3],
        quality: 0.8,
        allowsMultipleSelection: false
      });

      if (!result.canceled && result.assets[0]) {
        if (images.length < 5) {
          setImages([...images, result.assets[0].uri]);
        } else {
          Alert.alert("Limite atteinte", "Vous ne pouvez ajouter que 5 photos maximum");
        }
      }
    } catch (error) {
      Alert.alert("Erreur", "Impossible de sélectionner l'image");
    }
  };

  const takePicture = async () => {
    try {
      const permissionResult = await ImagePicker.requestCameraPermissionsAsync();
      
      if (permissionResult.granted === false) {
        Alert.alert("Permission refusée", "L'accès à la caméra est nécessaire");
        return;
      }

      const result = await ImagePicker.launchCameraAsync({
        allowsEditing: true,
        aspect: [4, 3],
        quality: 0.8
      });

      if (!result.canceled && result.assets[0]) {
        if (images.length < 5) {
          setImages([...images, result.assets[0].uri]);
        } else {
          Alert.alert("Limite atteinte", "Vous ne pouvez ajouter que 5 photos maximum");
        }
      }
    } catch (error) {
      Alert.alert("Erreur", "Impossible de prendre une photo");
    }
  };

  const removeImage = (index: number) => {
    setImages(images.filter((_, i) => i !== index));
  };

  const TabButton = ({ type, label }: { type: ListingType; label: string }) => (
    <TouchableOpacity
      style={{
        flex: 1,
        paddingVertical: 12,
        backgroundColor: listingType === type ? t.primaryBtn : t.cardBg,
        borderRadius: 8,
        alignItems: 'center',
        borderWidth: 1,
        borderColor: listingType === type ? t.primaryBtn : t.border
      }}
      onPress={() => setListingType(type)}
    >
      <Text style={{
        color: listingType === type ? t.white : t.heading,
        fontWeight: '600',
        fontSize: 16
      }}>
        {label}
      </Text>
    </TouchableOpacity>
  );

  const InputField = ({ 
    label, 
    value, 
    onChangeText, 
    placeholder, 
    multiline = false,
    keyboardType = "default" as any
  }: {
    label: string;
    value: string;
    onChangeText: (text: string) => void;
    placeholder: string;
    multiline?: boolean;
    keyboardType?: any;
  }) => (
    <View style={{ marginBottom: 16 }}>
      <Text style={{
        fontSize: 16,
        fontWeight: '600',
        color: t.heading,
        marginBottom: 8
      }}>
        {label} <Text style={{ color: '#FF6B6B' }}>*</Text>
      </Text>
      <TextInput
        style={{
          backgroundColor: t.cardBg,
          borderRadius: 8,
          paddingHorizontal: 16,
          paddingVertical: 12,
          borderWidth: 1,
          borderColor: t.border,
          fontSize: 16,
          color: t.heading,
          minHeight: multiline ? 100 : 50,
          textAlignVertical: multiline ? 'top' : 'center'
        }}
        value={value}
        onChangeText={onChangeText}
        placeholder={placeholder}
        placeholderTextColor={t.muted}
        multiline={multiline}
        keyboardType={keyboardType}
        blurOnSubmit={false}
        returnKeyType={multiline ? "default" : "next"}
        autoCorrect={false}
        autoCapitalize="sentences"
      />
    </View>
  );

  const SelectField = ({ 
    label, 
    value, 
    options, 
    onSelect, 
    placeholder 
  }: {
    label: string;
    value: string;
    options: { label: string; value: string }[];
    onSelect: (value: string) => void;
    placeholder: string;
  }) => (
    <View style={{ marginBottom: 16 }}>
      <Text style={{
        fontSize: 16,
        fontWeight: '600',
        color: t.heading,
        marginBottom: 8
      }}>
        {label} <Text style={{ color: '#FF6B6B' }}>*</Text>
      </Text>
      <ScrollView 
        horizontal 
        showsHorizontalScrollIndicator={false}
        keyboardShouldPersistTaps="handled"
      >
        <View style={{ flexDirection: 'row', gap: 8, paddingBottom: 4 }}>
          {options.map((option) => (
            <TouchableOpacity
              key={option.value}
              style={{
                paddingHorizontal: 16,
                paddingVertical: 8,
                borderRadius: 20,
                backgroundColor: value === option.value ? t.primaryBtn : t.cardBg,
                borderWidth: 1,
                borderColor: value === option.value ? t.primaryBtn : t.border
              }}
              onPress={() => onSelect(option.value)}
            >
              <Text style={{
                color: value === option.value ? t.white : t.heading,
                fontWeight: '500',
                fontSize: 14
              }}>
                {option.label}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </ScrollView>
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
        paddingVertical: 16,
        flexDirection: 'row',
        alignItems: 'center'
      }}>
        <TouchableOpacity 
          onPress={() => router.back()}
          style={{
            marginRight: 16,
            padding: 8
          }}
        >
          <Text style={{ fontSize: 18, color: t.primaryBtn }}>←</Text>
        </TouchableOpacity>
        <Text style={{
          fontSize: 20,
          fontWeight: 'bold',
          color: t.heading,
          flex: 1
        }}>
          Publier une annonce
        </Text>
      </View>

      <KeyboardAwareScrollView
        enableOnAndroid
        extraScrollHeight={80}
        keyboardOpeningTime={0}
        keyboardShouldPersistTaps="always"
        contentContainerStyle={{ paddingBottom: 50, flexGrow: 1 }}
        showsVerticalScrollIndicator={false}
      >
        {/* Type Selection */}
        <View style={{ paddingHorizontal: 16, paddingTop: 16 }}>
          <Text style={{
            fontSize: 18,
            fontWeight: 'bold',
            color: t.heading,
            marginBottom: 16
          }}>
            Type d'annonce
          </Text>
          
          <View style={{ flexDirection: 'row', gap: 12, marginBottom: 24 }}>
            <TypeTabButton t={t} type="sell" currentType={listingType} label="💰 Vendre" onPress={() => setListingType('sell')} />
            <TypeTabButton t={t} type="exchange" currentType={listingType} label="🔄 Échanger" onPress={() => setListingType('exchange')} />
          </View>
        </View>

        {/* Form */}
        <View style={{ paddingHorizontal: 16 }}>
          {/* Title */}
          <FormInputField t={t}
            label="Titre de l'annonce"
            value={title}
            onChangeText={setTitle}
            placeholder="Ex: AK-74 Kalashnikov réplique"
          />

          {/* Description */}
          <FormInputField t={t}
            label="Description"
            value={description}
            onChangeText={setDescription}
            placeholder="Décrivez votre matériel, son état, ses caractéristiques..."
            multiline={true}
          />

          {/* Category */}
          <FormSelectField t={t}
            label="Catégorie"
            value={category}
            options={CATEGORIES.map(cat => ({ label: cat.label, value: cat.slug }))}
            onSelect={setCategory}
            placeholder="Sélectionnez une catégorie"
          />

          {/* Condition */}
          <FormSelectField t={t}
            label="État"
            value={condition}
            options={CONDITIONS.map((cond: string) => ({ label: cond, value: cond }))}
            onSelect={setCondition}
            placeholder="État du matériel"
          />

          {/* Brand */}
          <FormSelectField t={t}
            label="Marque"
            value={brand}
            options={BRANDS.map((b: string) => ({ label: b, value: b }))}
            onSelect={setBrand}
            placeholder="Marque du produit"
          />

          {/* Price or Exchange */}
          {listingType === "sell" ? (
            <FormInputField t={t}
              label="Prix"
              value={price}
              onChangeText={setPrice}
              placeholder="Ex: 250.00"
              keyboardType="numeric"
            />
          ) : (
            <>
              <FormInputField t={t}
                label="Recherche en échange"
                value={wantedItems}
                onChangeText={setWantedItems}
                placeholder="Décrivez ce que vous recherchez..."
                multiline={true}
              />
              <FormInputField t={t}
                label="Valeur estimée (optionnel)"
                value={exchangeValue}
                onChangeText={setExchangeValue}
                placeholder="Ex: 200.00"
                keyboardType="numeric"
              />
            </>
          )}

          {/* Images Section */}
          <View style={{ marginBottom: 24 }}>
            <Text style={{
              fontSize: 16,
              fontWeight: '600',
              color: t.heading,
              marginBottom: 8
            }}>
              Photos ({images.length}/5)
            </Text>
            
            {/* Photos sélectionnées */}
            {images.length > 0 && (
              <ScrollView 
                horizontal 
                showsHorizontalScrollIndicator={false}
                style={{ marginBottom: 12 }}
                keyboardShouldPersistTaps="handled"
              >
                <View style={{ flexDirection: 'row', gap: 8, paddingRight: 16 }}>
                  {images.map((imageUri, index) => (
                    <View key={index} style={{ position: 'relative' }}>
                      <Image 
                        source={{ uri: imageUri }}
                        style={{
                          width: 80,
                          height: 80,
                          borderRadius: 8,
                          backgroundColor: t.cardBg
                        }}
                      />
                      <TouchableOpacity
                        style={{
                          position: 'absolute',
                          top: -8,
                          right: -8,
                          backgroundColor: '#FF6B6B',
                          borderRadius: 12,
                          width: 24,
                          height: 24,
                          alignItems: 'center',
                          justifyContent: 'center'
                        }}
                        onPress={() => removeImage(index)}
                      >
                        <Text style={{ color: 'white', fontSize: 14, fontWeight: 'bold' }}>×</Text>
                      </TouchableOpacity>
                    </View>
                  ))}
                </View>
              </ScrollView>
            )}
            
            {/* Bouton d'ajout */}
            <TouchableOpacity 
              style={{
                backgroundColor: t.cardBg,
                borderRadius: 8,
                padding: 32,
                borderWidth: 2,
                borderColor: t.border,
                borderStyle: 'dashed',
                alignItems: 'center',
                opacity: images.length >= 5 ? 0.5 : 1
              }}
              onPress={pickImage}
              disabled={images.length >= 5}
            >
              <Text style={{ fontSize: 24, marginBottom: 8 }}>📷</Text>
              <Text style={{ color: t.muted, textAlign: 'center' }}>
                {images.length >= 5 ? 'Limite de 5 photos atteinte' : 'Ajouter des photos'}
                {images.length < 5 && `\n(${5 - images.length} restantes)`}
              </Text>
            </TouchableOpacity>
          </View>

          {/* Submit Button */}
          <TouchableOpacity
            style={{
              backgroundColor: t.primaryBtn,
              paddingVertical: 16,
              borderRadius: 12,
              alignItems: 'center',
              marginBottom: 32
            }}
            onPress={handleSubmit}
          >
            <Text style={{
              color: t.white,
              fontWeight: 'bold',
              fontSize: 18
            }}>
              {listingType === "sell" ? "Publier l'annonce de vente" : "Publier l'annonce d'échange"}
            </Text>
          </TouchableOpacity>
        </View>
  </KeyboardAwareScrollView>
    </SafeAreaView>
  );
}