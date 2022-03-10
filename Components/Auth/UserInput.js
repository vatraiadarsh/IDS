import React from "react";
import { Text, View, TextInput } from "react-native";

function UserInput({
  name,
  value,
  setValue,
  autoCapitalize = "none",
  keyboardType = "default",
  secureTextEntry = false,
}) {
  return (
    <View style={{ marginHorizontal: 24 }}>
      <Text style={{ fontSize: 14, color: "black" }}>{name}</Text>
      <TextInput
        autiCorrec={false}
        autoCapitalize={autoCapitalize}
        keyboardType={keyboardType}
        secureTextEntry={secureTextEntry}
        style={{
          borderBottomWidth: 0.5,
          height: 45,
          borderBottomColor: "#8e93a1",
          marginBottom: 30,
        }}
        value={value}
        onChangeText={(text) => setValue(text)}
      />
    </View>
  );
}

export default UserInput;
