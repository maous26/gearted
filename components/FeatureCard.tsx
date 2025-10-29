import React from "react";
import { View, Text } from "react-native";
import { THEMES, ThemeKey } from "../themes";

export function FeatureCard({
  title,
  bullet,
  icon,
  theme,
}: {
  title: string;
  bullet: string[];
  icon: string;
  theme: ThemeKey;
}) {
  const t = THEMES[theme];
  
  return (
    <View style={{
      backgroundColor: t.cardBg,
      borderRadius: 16,
      borderWidth: 1,
      borderColor: t.border,
      padding: 16,
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.1,
      shadowRadius: 4,
      elevation: 3,
      marginBottom: 12,
    }}>
      {/* Header */}
      <View style={{ 
        flexDirection: 'row', 
        alignItems: 'center', 
        gap: 12, 
        marginBottom: 12 
      }}>
        <View style={{
          width: 40,
          height: 40,
          borderRadius: 12,
          backgroundColor: t.pillBg,
          alignItems: 'center',
          justifyContent: 'center',
          borderWidth: 1,
          borderColor: t.border,
        }}>
          <Text style={{ fontSize: 18, color: t.primaryBtn }}>{icon}</Text>
        </View>
        <Text style={{
          fontSize: 16,
          fontWeight: '600',
          color: t.heading,
          flex: 1
        }}>
          {title}
        </Text>
      </View>
      
      {/* Content */}
      <View>
        {bullet.map((item, index) => (
          <View key={index} style={{
            flexDirection: 'row',
            alignItems: 'flex-start',
            gap: 8,
            marginBottom: index === bullet.length - 1 ? 0 : 8
          }}>
            <View style={{
              width: 16,
              height: 16,
              borderRadius: 8,
              backgroundColor: t.primaryBtn,
              alignItems: 'center',
              justifyContent: 'center',
              marginTop: 2
            }}>
              <Text style={{ 
                color: t.white, 
                fontSize: 10, 
                fontWeight: 'bold'
              }}>
                ✓
              </Text>
            </View>
            <Text style={{
              fontSize: 14,
              color: t.muted,
              flex: 1,
              lineHeight: 20
            }}>
              {item}
            </Text>
          </View>
        ))}
      </View>
    </View>
  );
}