import React, { useState } from "react";
import {
  ScrollView,
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StatusBar,
  Alert,
  Image,
  Dimensions
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { router } from "expo-router";
import { THEMES, ThemeKey } from "../../themes";
import { CATEGORIES } from "../../data/index";

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
  const [theme] = useState<ThemeKey>("ranger");
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
      <ScrollView horizontal showsHorizontalScrollIndicator={false}>
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

      <ScrollView style={{ flex: 1 }}>
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
            <TabButton type="sell" label="💰 Vendre" />
            <TabButton type="exchange" label="🔄 Échanger" />
          </View>
        </View>

        {/* Form */}
        <View style={{ paddingHorizontal: 16 }}>
          {/* Title */}
          <InputField
            label="Titre de l'annonce"
            value={title}
            onChangeText={setTitle}
            placeholder="Ex: AK-74 Kalashnikov réplique"
          />

          {/* Description */}
          <InputField
            label="Description"
            value={description}
            onChangeText={setDescription}
            placeholder="Décrivez votre matériel, son état, ses caractéristiques..."
            multiline={true}
          />

          {/* Category */}
          <SelectField
            label="Catégorie"
            value={category}
            options={CATEGORIES.map(cat => ({ label: cat.label, value: cat.slug }))}
            onSelect={setCategory}
            placeholder="Sélectionnez une catégorie"
          />

          {/* Condition */}
          <SelectField
            label="État"
            value={condition}
            options={CONDITIONS.map((cond: string) => ({ label: cond, value: cond }))}
            onSelect={setCondition}
            placeholder="État du matériel"
          />

          {/* Brand */}
          <SelectField
            label="Marque"
            value={brand}
            options={BRANDS.map((b: string) => ({ label: b, value: b }))}
            onSelect={setBrand}
            placeholder="Marque du produit"
          />

          {/* Price or Exchange */}
          {listingType === "sell" ? (
            <InputField
              label="Prix"
              value={price}
              onChangeText={setPrice}
              placeholder="Ex: 250.00"
              keyboardType="numeric"
            />
          ) : (
            <>
              <InputField
                label="Recherche en échange"
                value={wantedItems}
                onChangeText={setWantedItems}
                placeholder="Décrivez ce que vous recherchez..."
                multiline={true}
              />
              <InputField
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
              Photos
            </Text>
            <TouchableOpacity style={{
              backgroundColor: t.cardBg,
              borderRadius: 8,
              padding: 32,
              borderWidth: 2,
              borderColor: t.border,
              borderStyle: 'dashed',
              alignItems: 'center'
            }}>
              <Text style={{ fontSize: 24, marginBottom: 8 }}>📷</Text>
              <Text style={{ color: t.muted, textAlign: 'center' }}>
                Ajouter des photos{'\n'}(Jusqu'à 5 photos)
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
      </ScrollView>
    </SafeAreaView>
  );
}