import React, { useState } from "react";
import { Text, View, ScrollView } from "react-native";
import SubmitButton from "../Components/Auth/SubmitButton";
import UserInput from "../Components/Auth/UserInput";
import CircleLogo from "../Components/Auth/CircleLogo";
import { KeyboardAwareScrollView } from "react-native-keyboard-aware-scroll-view";

import axios from "axios";

const Signup = ({navigation}) => {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async () => {
    setLoading(true);
    if (!name || !email || !password) {
      alert("All fields are required");
      setLoading(false);
      console.log(name, email, password);
      return;
    }
    try {
      const { data } = await axios.post("http://localhost:8000/api/signup", {
        name,
        email,
        password,
      });
      console.log("Signin success", data);
      alert("Signup success");
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
          }}
        >
          Please Sign up
        </Text>
        <UserInput
          value={name}
          setValue={setName}
          autoCorrect={false}
          autoCapitalize="words"
          name="Name"
        />
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
          title="Sign up"
        />

        <Text
          style={{
            textAlign: "center",
            fontSize: 12,
            color: "black",
          }}
        >
          Already Joined?{" "}
          <Text onPress={() => navigation.navigate("Signin")} style={{ fontSize: 12, color: "red" }}>Sign In</Text>
        </Text>
      </View>
    </KeyboardAwareScrollView>
  );
};

export default Signup;
