import React, { useState } from "react";
import { Text, View, ScrollView } from "react-native";
import SubmitButton from "../Components/Auth/SubmitButton";
import UserInput from "../Components/Auth/UserInput";
import CircleLogo from "../Components/Auth/CircleLogo";
import { KeyboardAwareScrollView } from "react-native-keyboard-aware-scroll-view";

import axios from "axios";

const Signin = ({navigation}) => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async () => {
    setLoading(true);
    if (!email || !password) {
      alert("All fields are required");
      setLoading(false);
      console.log( email, password);
      return;
    }
    try {
      const { data } = await axios.post("http://localhost:8000/api/Signin", {
        email,
        password,
      });
      console.log("Signin success", data);
      alert("Signin success");
    } catch (error) {
      console.log(error);
    }
  };

  return (
    <KeyboardAwareScrollView>
      <View style={{ flex: 1, justifyContent: "center" }}>
        <CircleLogo />
        <Text
          style={{
            fontSize: 24,
            color: "#333",
            textAlign: "center",
            marginVertical:25,
          }}
        >
          Please Sign in
        </Text>
        <UserInput
          value={email}
          setValue={setEmail}
          autoCompleteType="email"
          keyboardType="email-address"
          name="Email"
        />
        <UserInput
          value={password}
          setValue={setPassword}
          secureTextEntry={true}
          autoCompleteType="password"
          name="Password"
        />

        <SubmitButton
          handleSubmit={handleSubmit}
          loading={loading}
          title="Sign in"
        />

        <Text
          style={{
            textAlign: "center",
            fontSize: 12,
            color: "black",
          }}
        >
          Not yet registered?{" "}
          <Text onPress={() => navigation.navigate("Signup")} style={{ fontSize: 12, color: "red" }}>Sign Up</Text>
          
        </Text>
        <Text style={{ marginVertical:25, textAlign: "center",fontSize: 12, color: "orange" }}>Forgot Password?</Text>
      </View>
    </KeyboardAwareScrollView>
  );
};

export default Signin;
