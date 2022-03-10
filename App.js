import React from "react";

import Signup from "./screens/Signup";
import Signin from "./screens/Signin";

import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { NavigationContainer } from "@react-navigation/native";

const Stack = createNativeStackNavigator();

const App = () => {
  return (
    <NavigationContainer >
      <Stack.Navigator initialRouteName="Signin" screenOptions={{headerShown:false}} >
        <Stack.Screen name="Signup" component={Signup} />
        <Stack.Screen name="Signin" component={Signin} />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default App;
