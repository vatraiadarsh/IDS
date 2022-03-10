import React, { useState } from "react";
import { Text, View, ScrollView } from "react-native";
import SubmitButton from "../Components/Auth/SubmitButton";
import UserInput from "../Components/Auth/UserInput";

import axios from "axios";

import CircleLogo from "../Components/Auth/CircleLogo";
import { KeyboardAwareScrollView } from "react-native-keyboard-aware-scroll-view";
import { API } from "../config";

const Signup = ({ navigation }) => {
  const [name, setName] = useState("adarsha");
  const [email, setEmail] = useState("adarsh@gmail.com");
  const [password, setPassword] = useState("ajsdjlak");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async () => {
    setLoading(true);
    if (!name || !email || !password) {
      alert("All fields are required");
      setLoading(false);

      return;
    }
    try {
      const { data } = await axios.post(`${API}/signup`, {
        name,
        email,
        password,
      }); 
      if (data.error) {
        alert(data.error);
        setLoading(false);
      } else {
        setLoading(false);
        console.log("Signin success", data);
        alert("Signup success");
      }
    } catch (error) {
      alert("signup failed try again");
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
          <Text
            onPress={() => navigation.navigate("Signin")}
            style={{ fontSize: 12, color: "red" }}
          >
            Sign In
          </Text>
        </Text>
      </View>
    </KeyboardAwareScrollView>
  );
};

export default Signup;
