import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/constants/size_phone.dart';
import 'package:qr_scaner_manrique/BRACore/enums/card_invitationtype_enum.dart';
import 'package:qr_scaner_manrique/BRACore/enums/invitation_type.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/datetime_extension.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/string_extensions.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entry_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/invitation_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class InvitationCard extends StatelessWidget {
  final InvitationResponse? invitation;
  final CardInvitationType cardInvitationType;
  final EntryResponse? entry;
  final VoidCallback onTap;
  final String? trailingIconName;
  final VoidCallback? trailingIconAction;
  final bool showArrow;
  final Widget? moreOptionsAction;
  const InvitationCard({
    Key? key,
    this.invitation,
    this.entry,
    required this.cardInvitationType,
    required this.onTap,
    this.trailingIconName,
    this.trailingIconAction,
    this.moreOptionsAction,
    this.showArrow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final stringLocations =
        AppLocalizationsGenerator.appLocalizations(context: context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 15, left: 14, right: 17, bottom: 20),
        margin: EdgeInsets.only(bottom: 16, left: 4, right: 4),
        decoration: BoxDecoration(
            color: theme.colorScheme.background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(blurRadius: 5, color: Colors.grey.withOpacity(0.6))
            ]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        BRAText(
                          text: cardInvitationType ==
                                  CardInvitationType.residentGateEntry
                              ? invitation?.tipo?.value ?? ''
                              : entry?.tipoAcceso?.value ?? '',
                          size: size.height < SizePhone.HEGTH_S ? 11 : 13.5,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    entry != null &&
                            entry!.tipoAcceso! == EntryAccessType.salida
                        ? Container()
                        : Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                                color: cardInvitationType ==
                                        CardInvitationType.residentGateEntry
                                    ? invitation?.tipoInvitado
                                        ?.invitationCardBackgroundColor
                                    : entry?.tipoCodigo
                                        ?.invitationCardBackgroundColor,
                                border: Border.all(
                                    color: cardInvitationType ==
                                            CardInvitationType.residentGateEntry
                                        ? invitation?.tipoInvitado
                                                ?.invitationCardLabelBackgroundColor ??
                                            Colors.grey
                                        : entry?.tipoCodigo
                                                ?.invitationCardLabelBackgroundColor ??
                                            Colors.grey,
                                    width: 1),
                                borderRadius: BorderRadius.circular(4)),
                            child: BRAText(
                              text: cardInvitationType ==
                                      CardInvitationType.residentGateEntry
                                  ? invitation?.tipoInvitado?.value ?? ''
                                  : entry?.tipoCodigo?.value ?? '',
                              size: 12,
                              color: cardInvitationType ==
                                      CardInvitationType.residentGateEntry
                                  ? invitation?.tipoInvitado
                                      ?.invitationCardLabelBackgroundColor
                                  : entry?.tipoCodigo
                                      ?.invitationCardLabelBackgroundColor,
                            ),
                          ),
                  ],
                ),
                // moreOptionsAction != null ? moreOptionsAction! : Container(),
                trailingIconName == null
                    ? Container()
                    : InkWell(
                        onTap: trailingIconAction,
                        child: SvgPicture.asset(
                          trailingIconName!,
                          height: 36,
                          width: 36,
                        ),
                      )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(20),
            //       color: theme.own().component,
            //     ),
            //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //     child: BRAText(
            //       text: invitation.tipoInvitado?.value ?? '',
            //       textStyle: theme.textTheme.bodyLarge!.copyWith(
            //         fontWeight: FontWeight.w500,
            //         fontSize: 10,
            //         color: theme.own().primareyTextColor,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://storage.googleapis.com/pinlet/Lugar/${cardInvitationType == CardInvitationType.residentGateEntry ? invitation?.imagenLugar : UserData.sharedInstance.placeSelected!.imagen}',
                    width: 34,
                    height: 34,
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: theme.highlightColor),
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Image(
                        height: 34,
                        width: 34,
                        image: AssetImage(
                          'assets/images/casa.png',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: size.width < SizePhone.WIDTH_S
                                  ? size.width * 0.45
                                  : size.width * 0.6,
                              child: BRAText(
                                text: cardInvitationType ==
                                        CardInvitationType.residentGateEntry
                                    ? invitation?.nombreInvitado ?? ''
                                    : entry?.nombreVisitante ?? '',
                                size: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            showArrow
                                ? Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 15,
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    SizedBox(
                      width: size.width * 0.6,
                      child: BRAText(
                        text: cardInvitationType ==
                                CardInvitationType.residentGateEntry
                            ? '${stringLocations.invitedByLabel}: ${invitation?.nombreResidente?.getFirstName.getFirstName} ${invitation?.nombreResidente?.getLastNameResp}'
                            : '${stringLocations.residentLabel}: ${entry?.nombresResidente} ${entry?.apellidosResidente}',
                        size: 11,
                        fontWeight: FontWeight.w500,
                        color: theme.own().primareyTextColor,
                      ),
                    ),
                    cardInvitationType == CardInvitationType.historial
                        ? SizedBox(
                            width: size.width * 0.6,
                            child: BRAText(
                              text:
                                  '${entry?.nombrePrimario?.substring(0, 3)}. ${entry?.primarioResidente}    ${entry?.nombreSecundario?.substring(0, 3)}. ${entry?.secundarioResidente}',
                              size: 11,
                              fontWeight: FontWeight.w500,
                              color: theme.own().primareyTextColor,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 13,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: theme.own().tertiaryTextColor!)),
                        padding: EdgeInsets.only(left: 12, top: 4, bottom: 5),
                        child: Row(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(ConstantsIcons.calendarIcon),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BRAText(
                                      text: cardInvitationType ==
                                              CardInvitationType
                                                  .residentGateEntry
                                          ? '${stringLocations.sinceDate}:'
                                          : '${stringLocations.dueDate}',
                                      size: 12,
                                      color: theme.own().secundaryTextColor,
                                    ),
                                    BRAText(
                                      text: (cardInvitationType ==
                                                  CardInvitationType
                                                      .residentGateEntry
                                              ? invitation?.fechaInicio != null
                                              : entry?.fechaCreacion != null)
                                          ? (cardInvitationType ==
                                                      CardInvitationType
                                                          .residentGateEntry
                                                  ? invitation!.fechaInicio!
                                                  : entry!.fechaCreacion!)
                                              .formtaStringDateInvitation
                                          : DateTime.now()
                                              .formtaStringDateInvitation,
                                      size: size.height > SizePhone.HEGTH_M
                                          ? 12
                                          : 11,
                                      fontWeight: FontWeight.w600,
                                      color: theme.own().secundaryTextColor,
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    cardInvitationType == CardInvitationType.residentGateEntry
                        ? Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: theme.own().tertiaryTextColor!)),
                              padding:
                                  EdgeInsets.only(left: 12, top: 4, bottom: 5),
                              child: Row(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                          ConstantsIcons.calendarIcon),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BRAText(
                                            text:
                                                '${stringLocations.sinceDate}: ',
                                            size: 12,
                                            color:
                                                theme.own().secundaryTextColor,
                                          ),
                                          invitation!.fechaTermino != null
                                              ? BRAText(
                                                  text: invitation!
                                                      .fechaTermino!
                                                      .formtaStringDateInvitation,
                                                  size: size.height >
                                                          SizePhone.HEGTH_M
                                                      ? 12
                                                      : 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: theme
                                                      .own()
                                                      .secundaryTextColor,
                                                )
                                              : Container()
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: theme.own().tertiaryTextColor!)),
                              padding:
                                  EdgeInsets.only(left: 12, top: 4, bottom: 5),
                              child: Row(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                          ConstantsIcons.calendarIcon),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BRAText(
                                            text:
                                                '${stringLocations.licensePlateLabel}: ',
                                            size: 12,
                                            color:
                                                theme.own().secundaryTextColor,
                                          ),
                                          BRAText(
                                            text:
                                                entry?.placaVisitante ?? '---',
                                            size:
                                                size.height > SizePhone.HEGTH_M
                                                    ? 12
                                                    : 11,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                theme.own().secundaryTextColor,
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
