import React from "react";
import { View, Image, Text } from "react-native";

const CircleLogo = () => {
  return (
    <View
      style={{
        justifyContent: "center",
        alignItems: "center",
        backgroundColor: "green",
      }}
    >
      <Text style={{ paddingVertical: 75, paddingHorizontal: 75 ,fontSize:21,color:"#ffff"}}>
      Parallax solution
      </Text>
      <Image
        source={require("../../assets/logo.png")}
        style={{ width: 100, height: 75, marginBottom:20}}
      />
      
    </View>
  );
};

export default CircleLogo;
