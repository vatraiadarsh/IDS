import React, { useState } from "react";
import { TouchableOpacity, View, Text } from "react-native";

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
      <TouchableOpacity>
        <>
          <Text>Home</Text>
        </>
      </TouchableOpacity>
      <TouchableOpacity>
        <>
          <Text>Apple</Text>
        </>
      </TouchableOpacity>
      <TouchableOpacity>
        <>
          <Text>Ball</Text>
        </>
      </TouchableOpacity>
      <TouchableOpacity>
        <>
          <Text>Account</Text>
        </>
      </TouchableOpacity>
    </View>
  );
};

export default FooterTabs;
