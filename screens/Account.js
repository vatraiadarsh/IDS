import React, { useContext } from "react";
import { Text, View, SafeAreaView } from "react-native";
import { AuthContext } from "../context/auth";
import FooterTabs from "../Components/nav/FooterTabs";

const Account = () => {
  const [state, setState] = useContext(AuthContext);
  const { name, email, role } = state.user;
  return (
    <SafeAreaView style={{ flex: 1 }}>
      <Text>Account</Text>
      <View>
        <View style={{alignItems:"center"}}>
          <Text style={{ fontSize: 22, color: "red" }}>
            Name: {name}
          </Text>
          <Text style={{ fontSize: 22, color: "red" }}>
            Email: {email}
          </Text>
          <Text style={{ fontSize: 22, color: "red" }}>
            Role: {role}
          </Text>
        </View>
      </View>

      {/* <View style={{ flex: 1, justifyContent: "flex-end" }}>
        <FooterTabs />
      </View> */}
    </SafeAreaView>
  );
};

export default Account;
