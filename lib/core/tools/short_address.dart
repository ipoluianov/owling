String shortAddress(String address) {
  // 0x19823719731972391723987 -> 0x1982...3987
  if (address.length < 10) {
    return address;
  }
  return "${address.substring(0, 6)}...${address.substring(address.length - 4)}";
}
