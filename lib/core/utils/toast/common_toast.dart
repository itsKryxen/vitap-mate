import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:vitapmate/core/exceptions.dart';
import 'package:vitapmate/core/router/paths.dart';
import 'package:vitapmate/src/api/vtop/vtop_errors.dart';

void _showDiscontinuedDialog(BuildContext context) {
  if (!context.mounted) return;

  material.showAdaptiveDialog<void>(
    context: context,
    builder:
        (dialogContext) => FDialog(
          direction: Axis.horizontal,
          title: const Text('App Discontinued'),
          body: const Text(
            'Vitap Mate has been discontinued. Thank you for being part of it.',
          ),
          actions: [
            FButton(
              onPress: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
  );
}

void disCommonToast(BuildContext context, Object e) {
  if (!context.mounted) return;
  
  // } else {
  //   showFToast(
  //     context: context,
  //     alignment: FToastAlignment.bottomCenter,
  //     title: const Text('Error oocured'),

  //     description: const Text('Please try again'),
  //     suffixBuilder:
  //         (context, entry) => IntrinsicHeight(
  //           child: FButton(
  //             style:
  //                 context.theme.buttonStyles.primary
  //                     .copyWith(
  //                       contentStyle:
  //                           context.theme.buttonStyles.primary.contentStyle
  //                               .copyWith(
  //                                 padding: const EdgeInsets.symmetric(
  //                                   horizontal: 12,
  //                                   vertical: 7.5,
  //                                 ),
  //                                 textStyle: FWidgetStateMap.all(
  //                                   context.theme.typography.xs.copyWith(
  //                                     color:
  //                                         context
  //                                             .theme
  //                                             .colors
  //                                             .primaryForeground,
  //                                   ),
  //                                 ),
  //                               )
  //                               .call,
  //                     )
  //                     .call,
  //             onPress: entry.dismiss,
  //             child: const Text('Aye'),
  //           ),
  //         ),
  //   );
  // }
  _showDiscontinuedDialog(context);
}

void disOnbardingCommonToast(BuildContext context, Object e) {
  // if (e == VtopError.invalidCredentials()) {
  //   showFToast(
  //     context: context,
  //     alignment: FToastAlignment.bottomCenter,
  //     title: const Text('Login Failed'),
  //     description: const Text(
  //       'The username or password you entered is incorrect.',
  //     ),
  //     suffixBuilder:
  //         (context, entry) => IntrinsicHeight(
  //           child: FButton(
  //             style:
  //                 context.theme.buttonStyles.primary
  //                     .copyWith(
  //                       contentStyle:
  //                           context.theme.buttonStyles.primary.contentStyle
  //                               .copyWith(
  //                                 padding: const EdgeInsets.symmetric(
  //                                   horizontal: 12,
  //                                   vertical: 7.5,
  //                                 ),
  //                                 textStyle: FWidgetStateMap.all(
  //                                   context.theme.typography.xs.copyWith(
  //                                     color:
  //                                         context
  //                                             .theme
  //                                             .colors
  //                                             .primaryForeground,
  //                                   ),
  //                                 ),
  //                               )
  //                               .call,
  //                     )
  //                     .call,
  //             onPress: entry.dismiss,
  //             child: const Text('Aye'),
  //           ),
  //         ),
  //   );
  // } else if (e == VtopError.networkError()) {
  //   showFToast(
  //     context: context,
  //     alignment: FToastAlignment.bottomCenter,
  //     title: const Text('No Internet Connection'),
  //     description: const Text(
  //       "You're offline. Please check your connection and try again",
  //     ),
  //     suffixBuilder:
  //         (context, entry) => IntrinsicHeight(
  //           child: FButton(
  //             style:
  //                 context.theme.buttonStyles.primary
  //                     .copyWith(
  //                       contentStyle:
  //                           context.theme.buttonStyles.primary.contentStyle
  //                               .copyWith(
  //                                 padding: const EdgeInsets.symmetric(
  //                                   horizontal: 12,
  //                                   vertical: 7.5,
  //                                 ),
  //                                 textStyle: FWidgetStateMap.all(
  //                                   context.theme.typography.xs.copyWith(
  //                                     color:
  //                                         context
  //                                             .theme
  //                                             .colors
  //                                             .primaryForeground,
  //                                   ),
  //                                 ),
  //                               )
  //                               .call,
  //                     )
  //                     .call,
  //             onPress: entry.dismiss,
  //             child: const Text('Aye'),
  //           ),
  //         ),
  //   );
  // } else if (e is FeatureDisabledException) {
  //   _showDiscontinuedDialog(context);
  // }
  _showDiscontinuedDialog(context);
}

void dispToast(BuildContext context, String title, String des) {
  showFToast(
    context: context,
    alignment: FToastAlignment.bottomCenter,
    title: Text(title),
    //description: const Text('Visit this page for more information.'),
    description: Text(des),
    suffixBuilder:
        (context, entry) => IntrinsicHeight(
          child: FButton(
            style:
                context.theme.buttonStyles.primary
                    .copyWith(
                      contentStyle:
                          context.theme.buttonStyles.primary.contentStyle
                              .copyWith(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7.5,
                                ),
                                textStyle: FWidgetStateMap.all(
                                  context.theme.typography.xs.copyWith(
                                    color:
                                        context.theme.colors.primaryForeground,
                                  ),
                                ),
                              )
                              .call,
                    )
                    .call,
            onPress: entry.dismiss,
            child: const Text('Aye'),
          ),
        ),
  );
}
