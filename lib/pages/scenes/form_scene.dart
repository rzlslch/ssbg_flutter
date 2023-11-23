import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';

class FormScene extends StatelessWidget {
  const FormScene({super.key});

  @override
  Widget build(BuildContext context) {
    Timer? debounce;
    GlobalProvider globalProvider =
        Provider.of<GlobalProvider>(context, listen: false);
    return Expanded(
        child: ListView(
      children: globalProvider.config.entries
          .map((e) => Material(
                child: Row(
                  children: [
                    SizedBox(width: 80, child: Text(e.key)),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: e.value),
                        onChanged: (value) {
                          if (debounce?.isActive ?? false) debounce?.cancel();
                          debounce =
                              Timer(const Duration(milliseconds: 500), () {
                            Map<String, String> config =
                                Map<String, String>.from(globalProvider.config);
                            config[e.key] = value;
                            globalProvider.setConfig(config);
                            File configFile = File(join(globalProvider.blogDir,
                                "_config", "_config.yaml"));
                            String configString = config.entries
                                .map((e) => "${e.key}: \"${e.value}\"\n")
                                .join();
                            configFile.writeAsString(configString);
                          });
                        },
                      ),
                    )
                  ],
                ),
              ))
          .toList(),
    ));
  }
}
