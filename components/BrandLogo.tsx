import { LinearGradient } from "expo-linear-gradient";
import React from "react";
import { Text, View } from "react-native";
import { THEMES, ThemeKey } from "../themes";

// Grenade-style G logo component
function GrenadeLogo({ size, theme }: { size: number; theme: ThemeKey }) {
  const t = THEMES[theme];
  
  return (
    <View style={{
      width: size,
      height: size,
      alignItems: 'center',
      justifyContent: 'center',
    }}>
      {/* Grenade body */}
      <LinearGradient
        colors={t.gradientColors}
        start={{ x: 0, y: 0 }}
        end={{ x: 1, y: 1 }}
        style={{
          width: size * 0.8,
          height: size * 0.9,
          borderRadius: size * 0.15,
          alignItems: 'center',
          justifyContent: 'center',
          position: 'relative',
        }}
      >
        {/* Pin/lever at top */}
        <View style={{
          position: 'absolute',
          top: -size * 0.1,
          right: size * 0.1,
          width: size * 0.15,
          height: size * 0.2,
          backgroundColor: t.gradientColors[0],
          borderRadius: size * 0.05,
        }} />
        
        {/* G letter */}
        <Text style={{
          color: '#FFFFFF',
          fontSize: size * 0.4,
          fontWeight: 'bold',
          fontFamily: 'System',
          textAlign: 'center',
          marginTop: size * 0.05,
        }}>
          G
        </Text>
        
        {/* Shopping cart wheels */}
        <View style={{
          position: 'absolute',
          bottom: -size * 0.15,
          flexDirection: 'row',
          gap: size * 0.1,
        }}>
          <View style={{
            width: size * 0.08,
            height: size * 0.08,
            borderRadius: size * 0.04,
            backgroundColor: t.gradientColors[0],
          }} />
          <View style={{
            width: size * 0.08,
            height: size * 0.08,
            borderRadius: size * 0.04,
            backgroundColor: t.gradientColors[0],
          }} />
        </View>
      </LinearGradient>
    </View>
  );
}

export function BrandLogo({ 
  theme, 
  size = "medium",
  showText = true 
}: { 
  theme: ThemeKey; 
  size?: "small" | "medium" | "large";
  showText?: boolean;
}) {
  const t = THEMES[theme];
  
  const sizeConfig = {
    small: { logoSize: 28, fontSize: 14, spacing: 8 },
    medium: { logoSize: 36, fontSize: 18, spacing: 10 },
    large: { logoSize: 48, fontSize: 24, spacing: 12 }
  };
  
  const config = sizeConfig[size];
  
  return (
    <View style={{ 
      flexDirection: 'row', 
      alignItems: 'center',
      gap: config.spacing
    }}>
      <GrenadeLogo size={config.logoSize} theme={theme} />
      {showText && (
        <View>
          <Text style={{
            color: t.heading,
            fontSize: config.fontSize,
            fontWeight: 'bold',
            fontFamily: 'System',
            letterSpacing: -0.5,
          }}>
            GEARTED
          </Text>
          <Text style={{
            color: t.muted,
            fontSize: config.fontSize * 0.6,
            fontWeight: '500',
            fontFamily: 'System',
            letterSpacing: 0.5,
            textTransform: 'uppercase',
          }}>
            Airsoft Gear Buy & Sell
          </Text>
        </View>
      )}
    </View>
  );
}