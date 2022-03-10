import React, { useContext } from "react";
import { Text, View, SafeAreaView } from "react-native";
import { AuthContext } from "../context/auth";
import FooterTabs from "../Components/nav/FooterTabs";

const Account = () => {
  const [state, setState] = useContext(AuthContext);

  return (
    <SafeAreaView style={{ flex: 1 }}>
      <Text>Account</Text>

      <View style={{ flex: 1, justifyContent: "flex-end" }}>
        <FooterTabs />
      </View>
    </SafeAreaView>
  );
};

export default Account;
