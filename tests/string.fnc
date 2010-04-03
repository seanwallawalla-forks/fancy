FancySpec describe: String with: |it| {
  it should: "be the empty string on initialization" when: {
    str = String new;
    str should_equal: ""
  };
  
  it should: "be the concatination of the strings" when: {
    str1 = "hello ";
    str2 = "world";
    str3 = "!";
    str1 + str2 + str3 should_equal: "hello world!"
  }
}
