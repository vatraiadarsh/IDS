import React from "react";

import Signup from "../../screens/Signup";
import Signin from "../../screens/Signin";
import Home from "../../screens/Home";

import { createNativeStackNavigator } from "@react-navigation/native-stack";

const Stack = createNativeStackNavigator();

const ScreensNav = () => {
  return (
    <Stack.Navigator
      initialRouteName="Home"
      screenOptions={{ headerShown: false }}
    >
      <Stack.Screen name="Signup" component={Signup} />
      <Stack.Screen name="Signin" component={Signin} />
      <Stack.Screen name="Home" component={Home} />
    </Stack.Navigator>
  );
};

export default ScreensNav;
