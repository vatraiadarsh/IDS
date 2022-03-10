import React, { useContext } from "react";

import Signup from "../../screens/Signup";
import Signin from "../../screens/Signin";
import Home from "../../screens/Home";

import { Text } from "react-native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { AuthContext } from "../../context/auth";
import Headertabs from "./Headertabs";
import Account from "../../screens/Account";
import DemoScreen1 from "../../screens/DemoScreen1";
import DemoScreen2 from "../../screens/DemoScreen2";

const Stack = createNativeStackNavigator();

const ScreensNav = () => {
  const [state, useState] = useContext(AuthContext);
  const authenticated = state && state.token !== "" && state.user !== "";
  // console.log("Authenticated",authenticated)

  return (
    <Stack.Navigator
      initialRouteName="Home"
      //   screenOptions={{ headerShown: false }}
    >
      {authenticated ? (
        <>
          <Stack.Screen
            name="Home"
            component={Home}
            options={{
              title: "Parallax solution",
              headerRight: () => (
                <Text>
                  <Headertabs />
                </Text>
              ),
            }}
          />

          <Stack.Screen name="Demo1" component={DemoScreen1} />
          <Stack.Screen name="Demo2" component={DemoScreen2} />
          <Stack.Screen name="Account" component={Account} />
        </>
      ) : (
        <>
          <Stack.Screen
            name="Signin"
            component={Signin}
            options={{ headerShown: false }}
          />
          <Stack.Screen
            name="Signup"
            component={Signup}
            options={{ headerShown: false }}
          />
        </>
      )}
    </Stack.Navigator>
  );
};

export default ScreensNav;
