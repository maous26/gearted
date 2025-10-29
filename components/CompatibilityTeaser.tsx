import React, { useState } from "react";
import { Modal, ScrollView, Text, TouchableOpacity, View } from "react-native";
import { THEMES, ThemeKey } from "../themes";

// Simulate dropdown data
const WEAPON_TYPES = [
  "Assault Rifle",
  "SMG",
  "Sniper Rifle",
  "Pistol",
  "LMG",
  "Shotgun"
];

const BRANDS = [
  "Tokyo Marui",
  "KWA",
  "VFC",
  "G&G",
  "Krytac",
  "ASG"
];

interface DropdownProps {
  label: string;
  value: string;
  options: string[];
  onSelect: (value: string) => void;
  theme: ThemeKey;
}

function Dropdown({ label, value, options, onSelect, theme }: DropdownProps) {
  const [isOpen, setIsOpen] = useState(false);
  const t = THEMES[theme];

  return (
    <View style={{ flex: 1, marginHorizontal: 4 }}>
      <Text style={{ 
        color: t.muted, 
        fontSize: 12, 
        marginBottom: 4,
        fontWeight: '500'
      }}>
        {label}
      </Text>
      <TouchableOpacity
        onPress={() => setIsOpen(true)}
        style={{
          backgroundColor: t.cardBg,
          borderWidth: 1,
          borderColor: t.border,
          borderRadius: 8,
          paddingHorizontal: 12,
          paddingVertical: 10,
          minHeight: 40,
          justifyContent: 'center',
        }}
      >
        <Text style={{ 
          color: value ? t.heading : t.muted,
          fontSize: 14
        }}>
          {value || `Select ${label.toLowerCase()}`}
        </Text>
      </TouchableOpacity>

      <Modal
        visible={isOpen}
        transparent
        animationType="fade"
        onRequestClose={() => setIsOpen(false)}
      >
        <TouchableOpacity
          style={{
            flex: 1,
            backgroundColor: 'rgba(0,0,0,0.5)',
            justifyContent: 'center',
            alignItems: 'center',
          }}
          onPress={() => setIsOpen(false)}
        >
          <View style={{
            backgroundColor: t.cardBg,
            borderRadius: 12,
            padding: 16,
            width: '80%',
            maxHeight: '60%',
            borderWidth: 1,
            borderColor: t.border,
          }}>
            <Text style={{
              color: t.heading,
              fontSize: 16,
              fontWeight: 'bold',
              marginBottom: 12,
              textAlign: 'center'
            }}>
              Select {label}
            </Text>
            <ScrollView>
              {options.map((option) => (
                <TouchableOpacity
                  key={option}
                  onPress={() => {
                    onSelect(option);
                    setIsOpen(false);
                  }}
                  style={{
                    paddingVertical: 12,
                    paddingHorizontal: 8,
                    borderBottomWidth: 1,
                    borderBottomColor: t.border,
                  }}
                >
                  <Text style={{
                    color: t.heading,
                    fontSize: 14,
                    textAlign: 'center'
                  }}>
                    {option}
                  </Text>
                </TouchableOpacity>
              ))}
            </ScrollView>
          </View>
        </TouchableOpacity>
      </Modal>
    </View>
  );
}

export function CompatibilityTeaser({ 
  theme,
  onOpenDrawer 
}: { 
  theme: ThemeKey;
  onOpenDrawer?: () => void;
}) {
  const [weaponType, setWeaponType] = useState("");
  const [brand, setBrand] = useState("");
  const t = THEMES[theme];

  const canCheck = weaponType && brand;

  return (
    <View style={{
      backgroundColor: t.cardBg,
      borderRadius: 12,
      padding: 16,
      borderWidth: 1,
      borderColor: t.border,
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.1,
      shadowRadius: 4,
      elevation: 3,
    }}>
      <Text style={{
        color: t.heading,
        fontSize: 16,
        fontWeight: 'bold',
        marginBottom: 8,
        textAlign: 'center'
      }}>
        🔧 Quick Compatibility Check
      </Text>
      
      <Text style={{
        color: t.muted,
        fontSize: 12,
        textAlign: 'center',
        marginBottom: 16
      }}>
        Find compatible parts for your airsoft weapon
      </Text>

      <View style={{ 
        flexDirection: 'row',
        marginBottom: 16,
        gap: 8
      }}>
        <Dropdown
          label="Weapon Type"
          value={weaponType}
          options={WEAPON_TYPES}
          onSelect={setWeaponType}
          theme={theme}
        />
        <Dropdown
          label="Brand"
          value={brand}
          options={BRANDS}
          onSelect={setBrand}
          theme={theme}
        />
      </View>

      <TouchableOpacity
        onPress={onOpenDrawer}
        disabled={!canCheck}
        style={{
          backgroundColor: canCheck ? t.primaryBtn : t.border,
          borderRadius: 8,
          paddingVertical: 12,
          paddingHorizontal: 16,
          alignItems: 'center',
        }}
      >
        <Text style={{
          color: canCheck ? t.white : t.muted,
          fontSize: 14,
          fontWeight: '600'
        }}>
          {canCheck ? "Check Compatibility" : "Select weapon details"}
        </Text>
      </TouchableOpacity>
    </View>
  );
}