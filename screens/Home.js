import React, { useContext } from "react";
import { Text, View, SafeAreaView } from "react-native";
import { AuthContext } from "../context/auth";
import FooterTabs from "../Components/nav/FooterTabs";

const Home = () => {

    const [state,setState] = useContext(AuthContext);

  return (
    <SafeAreaView style={{flex:1,justifyContent:"space-between"}}>
      <Text>Home Page
          
      </Text>
      <Text>{JSON.stringify(state, null,4)}</Text>
      <FooterTabs/>
    </SafeAreaView>
  );
};

export default Home;
