import React, { useContext } from "react";
import { Text, View, SafeAreaView } from "react-native";
import { AuthContext } from "../context/auth";
import FooterTabs from "../Components/nav/FooterTabs";

const Home = () => {
  const [state, setState] = useContext(AuthContext);

  return (
    <SafeAreaView style={{ flex: 1 }}>
      <Text>Home Page</Text>
      <View style={{ flex: 1, justifyContent: "flex-end" }}>
        <FooterTabs />
      </View>
    </SafeAreaView>
  );
};

export default Home;
