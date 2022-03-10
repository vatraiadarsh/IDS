import React from "react";

import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { NavigationContainer } from "@react-navigation/native";
import { AuthProvider } from "./context/auth";
import ScreensNav from "./Components/nav/ScreensNav";

const Stack = createNativeStackNavigator();

const RootNavigation = () => {
  return (
    <NavigationContainer>
      <AuthProvider>
        <ScreensNav />
      </AuthProvider>
    </NavigationContainer>
  );
};

export default RootNavigation;
