import React, { useContext } from "react";
import { Text, View, SafeAreaView } from "react-native";
import { AuthContext } from "../context/auth";
import FooterTabs from "../Components/nav/FooterTabs";

const DemoScreen2 = () => {

    const [state,setState] = useContext(AuthContext);

  return (
    <SafeAreaView style={{flex:1}}>
      <Text>DemoScreen2 Page
          
      </Text>
      <View style={{flex:1,justifyContent:"flex-end"}}>
      <FooterTabs/>
      </View>
    </SafeAreaView>
  );
};

export default DemoScreen2;
