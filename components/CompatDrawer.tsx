import React from "react";
import { View, Text, TouchableOpacity, Modal, ScrollView, Dimensions } from "react-native";
import { THEMES, ThemeKey } from "../themes";

const { height: screenHeight } = Dimensions.get('window');

// Sample compatibility data
const COMPATIBILITY_RESULTS = [
  {
    category: "Magazines",
    items: [
      { name: "Tokyo Marui 30rd Magazine", compatibility: "100%", price: "$25" },
      { name: "G&P 120rd Mid-Cap", compatibility: "95%", price: "$18" },
      { name: "PTS EPM", compatibility: "90%", price: "$22" }
    ]
  },
  {
    category: "Barrels",
    items: [
      { name: "Prometheus 6.03mm Barrel", compatibility: "100%", price: "$45" },
      { name: "Lambda Five Barrel", compatibility: "95%", price: "$38" },
      { name: "Madbull 6.01mm Barrel", compatibility: "85%", price: "$32" }
    ]
  },
  {
    category: "Hop-up Units",
    items: [
      { name: "Maple Leaf Hop-up Chamber", compatibility: "100%", price: "$35" },
      { name: "G&G Green Hop-up", compatibility: "90%", price: "$28" },
      { name: "Lonex Hop-up Unit", compatibility: "85%", price: "$42" }
    ]
  }
];

interface CompatDrawerProps {
  isVisible: boolean;
  onClose: () => void;
  theme: ThemeKey;
  weaponType?: string;
  brand?: string;
}

export function CompatDrawer({ 
  isVisible, 
  onClose, 
  theme,
  weaponType = "Assault Rifle",
  brand = "Tokyo Marui"
}: CompatDrawerProps) {
  const t = THEMES[theme];

  const getCompatibilityColor = (percentage: string) => {
    const num = parseInt(percentage);
    if (num >= 95) return "#22c55e"; // green
    if (num >= 85) return "#eab308"; // yellow
    return "#ef4444"; // red
  };

  return (
    <Modal
      visible={isVisible}
      animationType="slide"
      presentationStyle="pageSheet"
      onRequestClose={onClose}
    >
      <View style={{
        flex: 1,
        backgroundColor: t.rootBg,
      }}>
        {/* Header */}
        <View style={{
          backgroundColor: t.navBg,
          paddingTop: 50,
          paddingBottom: 16,
          paddingHorizontal: 20,
          borderBottomWidth: 1,
          borderBottomColor: t.border,
        }}>
          <View style={{
            flexDirection: 'row',
            justifyContent: 'space-between',
            alignItems: 'center',
          }}>
            <View style={{ flex: 1 }}>
              <Text style={{
                color: t.heading,
                fontSize: 18,
                fontWeight: 'bold',
              }}>
                Compatibility Results
              </Text>
              <Text style={{
                color: t.muted,
                fontSize: 14,
                marginTop: 2,
              }}>
                {brand} {weaponType}
              </Text>
            </View>
            <TouchableOpacity
              onPress={onClose}
              style={{
                backgroundColor: t.border,
                borderRadius: 20,
                width: 32,
                height: 32,
                alignItems: 'center',
                justifyContent: 'center',
              }}
            >
              <Text style={{ color: t.heading, fontSize: 16, fontWeight: 'bold' }}>
                ×
              </Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* Content */}
        <ScrollView
          style={{ flex: 1 }}
          contentContainerStyle={{ padding: 20 }}
        >
          <Text style={{
            color: t.muted,
            fontSize: 14,
            textAlign: 'center',
            marginBottom: 24,
          }}>
            Compatible parts for your {brand} {weaponType}
          </Text>

          {COMPATIBILITY_RESULTS.map((category, categoryIndex) => (
            <View key={categoryIndex} style={{ marginBottom: 24 }}>
              <Text style={{
                color: t.heading,
                fontSize: 16,
                fontWeight: 'bold',
                marginBottom: 12,
              }}>
                {category.category}
              </Text>

              {category.items.map((item, itemIndex) => (
                <View
                  key={itemIndex}
                  style={{
                    backgroundColor: t.cardBg,
                    borderRadius: 8,
                    padding: 16,
                    marginBottom: 8,
                    borderWidth: 1,
                    borderColor: t.border,
                    flexDirection: 'row',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                  }}
                >
                  <View style={{ flex: 1 }}>
                    <Text style={{
                      color: t.heading,
                      fontSize: 14,
                      fontWeight: '500',
                      marginBottom: 4,
                    }}>
                      {item.name}
                    </Text>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                      <View style={{
                        backgroundColor: getCompatibilityColor(item.compatibility),
                        borderRadius: 4,
                        paddingHorizontal: 8,
                        paddingVertical: 2,
                        marginRight: 8,
                      }}>
                        <Text style={{
                          color: 'white',
                          fontSize: 12,
                          fontWeight: 'bold',
                        }}>
                          {item.compatibility}
                        </Text>
                      </View>
                      <Text style={{
                        color: t.muted,
                        fontSize: 12,
                      }}>
                        Compatibility
                      </Text>
                    </View>
                  </View>
                  <View style={{ alignItems: 'flex-end' }}>
                    <Text style={{
                      color: t.heading,
                      fontSize: 16,
                      fontWeight: 'bold',
                    }}>
                      {item.price}
                    </Text>
                    <TouchableOpacity
                      style={{
                        backgroundColor: t.primaryBtn,
                        borderRadius: 6,
                        paddingHorizontal: 12,
                        paddingVertical: 6,
                        marginTop: 4,
                      }}
                    >
                      <Text style={{
                        color: t.white,
                        fontSize: 12,
                        fontWeight: '600',
                      }}>
                        View
                      </Text>
                    </TouchableOpacity>
                  </View>
                </View>
              ))}
            </View>
          ))}

          {/* Bottom spacing */}
          <View style={{ height: 40 }} />
        </ScrollView>
      </View>
    </Modal>
  );
}