class ClientDetailsResponse {
  final String? id;
  final String? clientId;
  final String? name;
  final String? addr1;
  final String? addr2;
  final String? addr3;
  final String? addr4;
  final String? pin;
  final String? state;
  final String? nationality;
  final String? email;
  final String? email2;
  final String? phno;
  final String? mobNo1;
  final String? mobNo2;
  final String? dob;
  final String? gender;
  final String? panNo;
  final String? bankName;
  final String? branchName;
  final String? acNo;
  final String? ifscCode;
  final String? micrCode;
  final String? agentId;
  final String? fmlyName;
  final String? presentAddr1;
  final String? presentAddr2;
  final String? bankName2;
  final String? branchName2;
  final String? acNo2;
  final String? ifscCode2;
  final String? micrCode2;
  final String? downloadDte;
  final String? downloadFrom;
  final String? delFlg;
  final String? activeFlg;
  final String? cstmrLoginFlg;
  final String? userId;
  final String? bankCode;
  final String? branchAddress1;
  final String? branchCity;
  final String? branchPin;
  final String? bankAcType;
  final String? addressRepDate;

  ClientDetailsResponse({
    this.id,
    this.clientId,
    this.name,
    this.addr1,
    this.addr2,
    this.addr3,
    this.addr4,
    this.pin,
    this.state,
    this.nationality,
    this.email,
    this.email2,
    this.phno,
    this.mobNo1,
    this.mobNo2,
    this.dob,
    this.gender,
    this.panNo,
    this.bankName,
    this.branchName,
    this.acNo,
    this.ifscCode,
    this.micrCode,
    this.agentId,
    this.fmlyName,
    this.presentAddr1,
    this.presentAddr2,
    this.bankName2,
    this.branchName2,
    this.acNo2,
    this.ifscCode2,
    this.micrCode2,
    this.downloadDte,
    this.downloadFrom,
    this.delFlg,
    this.activeFlg,
    this.cstmrLoginFlg,
    this.userId,
    this.bankCode,
    this.branchAddress1,
    this.branchCity,
    this.branchPin,
    this.bankAcType,
    this.addressRepDate,
  });

  factory ClientDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ClientDetailsResponse(
      id: json['id'] as String?,
      clientId: json['client_id'] as String?,
      name: json['name'] as String?,
      addr1: json['addr1'] as String?,
      addr2: json['addr2'] as String?,
      addr3: json['addr3'] as String?,
      addr4: json['addr4'] as String?,
      pin: json['pin'] as String?,
      state: json['state'] as String?,
      nationality: json['nationality'] as String?,
      email: json['email'] as String?,
      email2: json['email2'] as String?,
      phno: json['phno'] as String?,
      mobNo1: json['mob_no1'] as String?,
      mobNo2: json['mob_no2'] as String?,
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
      panNo: json['pan_no'] as String?,
      bankName: json['bank_name'] as String?,
      branchName: json['branch_name'] as String?,
      acNo: json['ac_no'] as String?,
      ifscCode: json['ifsc_code'] as String?,
      micrCode: json['micr_code'] as String?,
      agentId: json['agent_id'] as String?,
      fmlyName: json['fmly_name'] as String?,
      presentAddr1: json['present_addr1'] as String?,
      presentAddr2: json['present_addr2'] as String?,
      bankName2: json['bank_name2'] as String?,
      branchName2: json['branch_name2'] as String?,
      acNo2: json['ac_no2'] as String?,
      ifscCode2: json['ifsc_code2'] as String?,
      micrCode2: json['micr_code2'] as String?,
      downloadDte: json['download_dte'] as String?,
      downloadFrom: json['download_from'] as String?,
      delFlg: json['del_flg'] as String?,
      activeFlg: json['active_flg'] as String?,
      cstmrLoginFlg: json['cstmr_login_flg'] as String?,
      userId: json['user_id'] as String?,
      bankCode: json['bank_code'] as String?,
      branchAddress1: json['branch_address1'] as String?,
      branchCity: json['branch_city'] as String?,
      branchPin: json['branch_pin'] as String?,
      bankAcType: json['bank_ac_type'] as String?,
      addressRepDate: json['address_rep_date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'name': name,
      'addr1': addr1,
      'addr2': addr2,
      'addr3': addr3,
      'addr4': addr4,
      'pin': pin,
      'state': state,
      'nationality': nationality,
      'email': email,
      'email2': email2,
      'phno': phno,
      'mob_no1': mobNo1,
      'mob_no2': mobNo2,
      'dob': dob,
      'gender': gender,
      'pan_no': panNo,
      'bank_name': bankName,
      'branch_name': branchName,
      'ac_no': acNo,
      'ifsc_code': ifscCode,
      'micr_code': micrCode,
      'agent_id': agentId,
      'fmly_name': fmlyName,
      'present_addr1': presentAddr1,
      'present_addr2': presentAddr2,
      'bank_name2': bankName2,
      'branch_name2': branchName2,
      'ac_no2': acNo2,
      'ifsc_code2': ifscCode2,
      'micr_code2': micrCode2,
      'download_dte': downloadDte,
      'download_from': downloadFrom,
      'del_flg': delFlg,
      'active_flg': activeFlg,
      'cstmr_login_flg': cstmrLoginFlg,
      'user_id': userId,
      'bank_code': bankCode,
      'branch_address1': branchAddress1,
      'branch_city': branchCity,
      'branch_pin': branchPin,
      'bank_ac_type': bankAcType,
      'address_rep_date': addressRepDate,
    };
  }
}
