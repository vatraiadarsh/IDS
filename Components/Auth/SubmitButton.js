import React from "react";
import { Text, TouchableOpacity } from "react-native";

const SubmitButton = ({title}) => (
  <TouchableOpacity
    style={{
      height: 50,
      marginBottom: 20,
      marginHorizontal: 25,
      borderRadius: 24,
      alignItems: "center",
      backgroundColor: "green",
      padding: 15,
    }}
  >
    <Text
      style={{
        color: "#ffff",
        fontSize: 15,
        fontWeight: "600",
      }}
    >
      {title}
    </Text>
  </TouchableOpacity>
);

export default SubmitButton;
