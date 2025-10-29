import React from "react";
import { View, Text, StyleSheet } from "react-native";
import { LinearGradient } from "expo-linear-gradient";

// Standalone Gearted Logo inspired by the official design
// Features a grenade-style "G" with shopping cart elements
export function GeartedStandaloneLogo({ 
  size = 120,
  colors = ["#4B5D3A", "#6B7A57"],
  showTagline = true 
}: { 
  size?: number;
  colors?: string[];
  showTagline?: boolean;
}) {
  
  return (
    <View style={[styles.container, { width: size * 1.5, height: size * 1.2 }]}>
      {/* Main Logo */}
      <View style={[styles.logoContainer, { width: size, height: size }]}>
        {/* Grenade body */}
        <LinearGradient
          colors={colors}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 1 }}
          style={[
            styles.grenadeBody,
            {
              width: size * 0.8,
              height: size * 0.9,
              borderRadius: size * 0.15,
            }
          ]}
        >
          {/* Pin/lever at top */}
          <View style={[
            styles.pin,
            {
              top: -size * 0.1,
              right: size * 0.1,
              width: size * 0.15,
              height: size * 0.2,
              backgroundColor: colors[0],
              borderRadius: size * 0.05,
            }
          ]} />
          
          {/* G letter */}
          <Text style={[
            styles.gLetter,
            {
              fontSize: size * 0.4,
              marginTop: size * 0.05,
            }
          ]}>
            G
          </Text>
          
          {/* Shopping cart wheels */}
          <View style={[
            styles.wheels,
            {
              bottom: -size * 0.15,
              gap: size * 0.1,
            }
          ]}>
            <View style={[
              styles.wheel,
              {
                width: size * 0.08,
                height: size * 0.08,
                borderRadius: size * 0.04,
                backgroundColor: colors[0],
              }
            ]} />
            <View style={[
              styles.wheel,
              {
                width: size * 0.08,
                height: size * 0.08,
                borderRadius: size * 0.04,
                backgroundColor: colors[0],
              }
            ]} />
          </View>
        </LinearGradient>
      </View>
      
      {/* Brand Text */}
      <View style={styles.textContainer}>
        <Text style={[
          styles.brandName,
          { fontSize: size * 0.25 }
        ]}>
          GEARTED
        </Text>
        {showTagline && (
          <Text style={[
            styles.tagline,
            { fontSize: size * 0.12 }
          ]}>
            AIRSOFT GEAR BUY & SELL
          </Text>
        )}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  logoContainer: {
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 16,
  },
  grenadeBody: {
    alignItems: 'center',
    justifyContent: 'center',
    position: 'relative',
  },
  pin: {
    position: 'absolute',
  },
  gLetter: {
    color: '#FFFFFF',
    fontWeight: 'bold',
    fontFamily: 'System',
    textAlign: 'center',
  },
  wheels: {
    position: 'absolute',
    flexDirection: 'row',
  },
  wheel: {
    // wheel styles are set inline due to dynamic sizing
  },
  textContainer: {
    alignItems: 'center',
  },
  brandName: {
    color: '#F5F0E1',
    fontWeight: 'bold',
    fontFamily: 'System',
    letterSpacing: 2,
    textAlign: 'center',
  },
  tagline: {
    color: '#8B7355',
    fontWeight: '500',
    fontFamily: 'System',
    letterSpacing: 1,
    textAlign: 'center',
    marginTop: 4,
  },
});