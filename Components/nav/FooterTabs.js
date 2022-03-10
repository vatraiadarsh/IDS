import React, { useState } from "react";
import { TouchableOpacity, View, Text } from "react-native";
import FontAwesome5 from "react-native-vector-icons/FontAwesome5";

export const Tab = (props) => (
  <TouchableOpacity>
    <>
      <FontAwesome5
        name={props.name}
        size={25}
        color="green"
        style={{
          marginBottom: 3,
          alignSelf: "center",
        }}
      ></FontAwesome5>
      <Text>{props.text}</Text>
    </>
  </TouchableOpacity>
);

const FooterTabs = () => {
  return (
    <View
      style={{
        flexDirection: "row",
        margin: 10,
        marginHorizontal: 30,
        justifyContent: "space-between",
      }}
    >
      
      <Tab name="home" text="Home"/>
      <Tab name="plus-square" text="Apple"/>
      <Tab name="list-ol" text="Ball"/>
      <Tab name="user" text="Account"/>
      
      </View>
  );
};

export default FooterTabs;
