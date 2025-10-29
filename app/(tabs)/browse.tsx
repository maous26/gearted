import React, { useState } from "react";
import { 
  ScrollView, 
  View, 
  Text, 
  TextInput, 
  TouchableOpacity, 
  StatusBar,
  Dimensions,
  Image
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { THEMES, ThemeKey } from "../../themes";
import { CATEGORIES } from "../../data";
import { CategoryPill } from "../../components/CategoryPill";

const { width } = Dimensions.get('window');

// Mock product data
const MOCK_PRODUCTS = [
  {
    id: "1",
    title: "AK-74 Kalashnikov Réplique",
    price: 289.99,
    condition: "Excellent",
    location: "Paris, 75001",
    seller: "AirsoftPro92",
    rating: 4.8,
    images: ["https://via.placeholder.com/200x150/4B5D3A/FFFFFF?text=AK-74"],
    category: "repliques",
    featured: true
  },
  {
    id: "2", 
    title: "Red Dot Sight - EOTech 552",
    price: 45.50,
    condition: "Très bon",
    location: "Lyon, 69000",
    seller: "TacticalGear",
    rating: 4.9,
    images: ["https://via.placeholder.com/200x150/8B4513/FFFFFF?text=Red+Dot"],
    category: "optiques",
    featured: false
  },
  {
    id: "3",
    title: "Gilet Tactique MultiCam",
    price: 120.00,
    condition: "Neuf",
    location: "Marseille, 13000", 
    seller: "MilSimStore",
    rating: 4.7,
    images: ["https://via.placeholder.com/200x150/556B2F/FFFFFF?text=Gilet"],
    category: "equipement",
    featured: true
  },
  {
    id: "4",
    title: "Billes 0.25g Bio (5000pcs)",
    price: 18.99,
    condition: "Neuf",
    location: "Toulouse, 31000",
    seller: "BioBB_Shop",
    rating: 4.6,
    images: ["https://via.placeholder.com/200x150/2F4F4F/FFFFFF?text=Billes"],
    category: "munitions",
    featured: false
  },
  {
    id: "5",
    title: "M4A1 Custom Build",
    price: 450.00,
    condition: "Excellent",
    location: "Nice, 06000",
    seller: "CustomBuilds",
    rating: 5.0,
    images: ["https://via.placeholder.com/200x150/4B5D3A/FFFFFF?text=M4A1"],
    category: "repliques", 
    featured: true
  },
  {
    id: "6",
    title: "Chargeur M4 120 billes",
    price: 12.50,
    condition: "Bon",
    location: "Bordeaux, 33000",
    seller: "PartsPro",
    rating: 4.4,
    images: ["https://via.placeholder.com/200x150/696969/FFFFFF?text=Chargeur"],
    category: "pieces",
    featured: false
  }
];

export default function BrowseScreen() {
  const [theme] = useState<ThemeKey>("ranger");
  const [searchText, setSearchText] = useState("");
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [sortBy, setSortBy] = useState<"recent" | "price_low" | "price_high" | "rating">("recent");
  
  const t = THEMES[theme];

  const filteredProducts = MOCK_PRODUCTS.filter(product => {
    const matchesSearch = searchText === "" || 
      product.title.toLowerCase().includes(searchText.toLowerCase()) ||
      product.seller.toLowerCase().includes(searchText.toLowerCase());
    
    const matchesCategory = selectedCategory === null || product.category === selectedCategory;
    
    return matchesSearch && matchesCategory;
  });

  const sortedProducts = [...filteredProducts].sort((a, b) => {
    switch (sortBy) {
      case "price_low":
        return a.price - b.price;
      case "price_high":
        return b.price - a.price;
      case "rating":
        return b.rating - a.rating;
      default:
        return 0; // Keep original order for "recent"
    }
  });

  const ProductCard = ({ product }: { product: typeof MOCK_PRODUCTS[0] }) => (
    <TouchableOpacity style={{
      backgroundColor: t.cardBg,
      borderRadius: 12,
      marginBottom: 16,
      borderWidth: 1,
      borderColor: t.border,
      overflow: 'hidden'
    }}>
      {/* Product Image */}
      <View style={{ position: 'relative' }}>
        <Image 
          source={{ uri: product.images[0] }}
          style={{ width: '100%', height: 150 }}
          resizeMode="cover"
        />
        {product.featured && (
          <View style={{
            position: 'absolute',
            top: 8,
            right: 8,
            backgroundColor: '#FFD166',
            paddingHorizontal: 8,
            paddingVertical: 4,
            borderRadius: 6
          }}>
            <Text style={{ fontSize: 10, fontWeight: '600', color: '#333' }}>
              ⭐ Featured
            </Text>
          </View>
        )}
        <View style={{
          position: 'absolute',
          top: 8,
          left: 8,
          backgroundColor: 'rgba(0,0,0,0.7)',
          paddingHorizontal: 8,
          paddingVertical: 4,
          borderRadius: 6
        }}>
          <Text style={{ fontSize: 10, fontWeight: '600', color: 'white' }}>
            {product.condition}
          </Text>
        </View>
      </View>

      {/* Product Details */}
      <View style={{ padding: 12 }}>
        <Text style={{
          fontSize: 16,
          fontWeight: '600',
          color: t.heading,
          marginBottom: 4
        }}>
          {product.title}
        </Text>
        
        <Text style={{
          fontSize: 20,
          fontWeight: 'bold',
          color: t.primaryBtn,
          marginBottom: 8
        }}>
          {product.price.toFixed(2)} €
        </Text>

        <View style={{
          flexDirection: 'row',
          justifyContent: 'space-between',
          alignItems: 'center',
          marginBottom: 8
        }}>
          <Text style={{
            fontSize: 12,
            color: t.muted
          }}>
            📍 {product.location}
          </Text>
          <View style={{ flexDirection: 'row', alignItems: 'center' }}>
            <Text style={{ fontSize: 12, color: '#FFD700', marginRight: 4 }}>⭐</Text>
            <Text style={{ fontSize: 12, color: t.muted }}>
              {product.rating} • {product.seller}
            </Text>
          </View>
        </View>

        <TouchableOpacity style={{
          backgroundColor: t.primaryBtn,
          paddingVertical: 8,
          borderRadius: 8,
          alignItems: 'center'
        }}>
          <Text style={{ color: t.white, fontWeight: '600', fontSize: 14 }}>
            Voir le détail
          </Text>
        </TouchableOpacity>
      </View>
    </TouchableOpacity>
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
          Marketplace
        </Text>
      </View>

      <ScrollView style={{ flex: 1 }}>
        {/* Search and Filters */}
        <View style={{ paddingHorizontal: 16, paddingTop: 16 }}>
          {/* Search Bar */}
          <View style={{
            backgroundColor: t.cardBg,
            borderRadius: 12,
            paddingHorizontal: 16,
            paddingVertical: 12,
            borderWidth: 1,
            borderColor: t.border,
            flexDirection: 'row',
            alignItems: 'center',
            marginBottom: 16
          }}>
            <TextInput
              style={{
                flex: 1,
                fontSize: 16,
                color: t.heading
              }}
              placeholder="Rechercher des produits..."
              value={searchText}
              onChangeText={setSearchText}
              placeholderTextColor={t.muted}
            />
            <TouchableOpacity style={{
              backgroundColor: t.primaryBtn,
              paddingHorizontal: 12,
              paddingVertical: 6,
              borderRadius: 6
            }}>
              <Text style={{ color: t.white, fontWeight: '600', fontSize: 12 }}>🔍</Text>
            </TouchableOpacity>
          </View>

          {/* Categories */}
          <Text style={{
            fontSize: 16,
            fontWeight: '600',
            color: t.heading,
            marginBottom: 12
          }}>
            Catégories
          </Text>
          
          <ScrollView 
            horizontal 
            showsHorizontalScrollIndicator={false}
            style={{ marginBottom: 16 }}
          >
            <TouchableOpacity 
              style={{
                paddingHorizontal: 16,
                paddingVertical: 8,
                borderRadius: 20,
                backgroundColor: selectedCategory === null ? t.primaryBtn : t.cardBg,
                borderWidth: 1,
                borderColor: t.border,
                marginRight: 8
              }}
              onPress={() => setSelectedCategory(null)}
            >
              <Text style={{
                color: selectedCategory === null ? t.white : t.heading,
                fontWeight: '600',
                fontSize: 12
              }}>
                Tout voir
              </Text>
            </TouchableOpacity>
            
            {CATEGORIES.map((category) => (
              <CategoryPill
                key={category.slug}
                label={category.label}
                icon={category.icon}
                onPress={() => setSelectedCategory(
                  selectedCategory === category.slug ? null : category.slug
                )}
                theme={theme}
              />
            ))}
          </ScrollView>

          {/* Sort Options */}
          <View style={{
            flexDirection: 'row',
            justifyContent: 'space-between',
            alignItems: 'center',
            marginBottom: 16
          }}>
            <Text style={{
              fontSize: 16,
              fontWeight: '600',
              color: t.heading
            }}>
              {sortedProducts.length} résultat{sortedProducts.length > 1 ? 's' : ''}
            </Text>
            
            <TouchableOpacity style={{
              backgroundColor: t.cardBg,
              paddingHorizontal: 12,
              paddingVertical: 6,
              borderRadius: 8,
              borderWidth: 1,
              borderColor: t.border
            }}>
              <Text style={{ color: t.heading, fontSize: 12 }}>
                📊 Trier
              </Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* Product Grid */}
        <View style={{ paddingHorizontal: 16, paddingBottom: 32 }}>
          {sortedProducts.map((product) => (
            <ProductCard key={product.id} product={product} />
          ))}
          
          {sortedProducts.length === 0 && (
            <View style={{
              backgroundColor: t.cardBg,
              borderRadius: 12,
              padding: 32,
              alignItems: 'center',
              borderWidth: 1,
              borderColor: t.border
            }}>
              <Text style={{
                fontSize: 18,
                color: t.muted,
                textAlign: 'center',
                marginBottom: 8
              }}>
                🔍 Aucun produit trouvé
              </Text>
              <Text style={{
                fontSize: 14,
                color: t.muted,
                textAlign: 'center'
              }}>
                Essayez de modifier vos filtres ou votre recherche
              </Text>
            </View>
          )}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}