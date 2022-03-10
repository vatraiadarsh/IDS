import React, { useState } from "react";
import { TouchableOpacity, View, Text } from "react-native";
import FontAwesome5 from "react-native-vector-icons/FontAwesome5";

import { useNavigation, useRoute } from "@react-navigation/native";
import { Divider } from "react-native-elements";

export const Tab = (props) => {
  const activeScreenColor = props.screenName === props.routeName && "red";
  return (
    <TouchableOpacity>
      <>
        <FontAwesome5
          name={props.name}
          size={25}
          style={{
            marginBottom: 3,
            alignSelf: "center",
            
          }}
          onPress={props.handlePress}
          color= { activeScreenColor }
        ></FontAwesome5>
        <Text onPress={props.handlePress}>{props.text}</Text>
      </>
    </TouchableOpacity>
  );
};

const FooterTabs = () => {
  const navigation = useNavigation();
  const route = useRoute();
  // console.log(route)

  return (
    <>
      <Divider width={1} />
      <View
        style={{
          flexDirection: "row",
          margin: 10,
          marginHorizontal: 30,
          justifyContent: "space-between",
        }}
      >
        <Tab
          name="home"
          text="Home"
          handlePress={() => navigation.navigate("Home")}
          screenName="Home"
          routeName={route.name}
        />
        <Tab
          name="plus-square"
          text="Demo1"
          handlePress={() => navigation.navigate("Demo1")}
          screenName="Demo1"
          routeName={route.name}
        />
        <Tab
          name="list-ol"
          text="Demo2"
          handlePress={() => navigation.navigate("Demo2")}
          screenName="Demo2"
          routeName={route.name}
        />
        <Tab
          name="user"
          text="Account"
          handlePress={() => navigation.navigate("Account")}
          screenName="Account"
          routeName={route.name}
        />
      </View>
    </>
  );
};

export default FooterTabs;
