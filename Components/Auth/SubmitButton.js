import React from "react";
import { Text, TouchableOpacity } from "react-native";

const SubmitButton = ({title,handleSubmit,loading}) => (
  <TouchableOpacity
  onPress={handleSubmit}
    style={{
      height: 54,
      marginBottom: 20,
      marginHorizontal: 25,
      borderRadius: 24,
      alignItems: "center",
      backgroundColor: "#1ceb4c",
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

      {loading ? "Please wait ....": title}
    </Text>
  </TouchableOpacity>
);

export default SubmitButton;
