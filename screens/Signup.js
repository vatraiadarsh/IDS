import React, { useState } from "react";
import { Text, View, TextInput } from "react-native";
import UserInput from "../Components/Auth/UserInput";

const Signup = () => {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  return (
    <View style={{ flex: 1, justifyContent: "center" }}>
      <Text
        style={{
          fontSize: 24,
          color: "#333",
          textAlign: "center",
        }}
      >
        Signup
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

      <Text>{JSON.stringify({ name, email, password }, null, 4)}</Text>
    </View>
  );
};

export default Signup;
