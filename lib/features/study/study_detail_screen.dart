import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

import '../../core/widgets/glass_card.dart';

import '../../core/widgets/responsive_layout.dart';

import 'study_data.dart';



class StudyDetailScreen extends StatelessWidget {

  final StudyTheme theme;



  const StudyDetailScreen({super.key, required this.theme});



  List<Widget> _buildRichContent(BuildContext context, String markdown) {

    final List<Widget> widgets = [];

    final lines = markdown.split('\n');

    final onSurface = AppColors.getOnSurface(context);



    for (var line in lines) {

      if (line.trim().isEmpty) {

        widgets.add(const SizedBox(height: 12));

      } else if (line.startsWith('### ')) {

        widgets.add(Padding(

          padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),

          child: Text(

            line.substring(4),

            style: TextStyle(

              fontSize: 22,

              fontWeight: FontWeight.w900,

              color: theme.primaryColor,

              letterSpacing: 1,

            ),

          ),

        ));

      } else if (line.startsWith('- ')) {

        // Parse bold markers inside bullets

        final text = line.substring(2);

        final spanChildren = <TextSpan>[];

        int lastIndex = 0;

        final boldRegex = RegExp(r'\*\*(.*?)\*\*');

        final matches = boldRegex.allMatches(text);



        for (var match in matches) {

          if (match.start > lastIndex) {

            spanChildren.add(TextSpan(text: text.substring(lastIndex, match.start)));

          }

          spanChildren.add(TextSpan(

            text: match.group(1),

            style: TextStyle(fontWeight: FontWeight.w900, color: onSurface),

          ));

          lastIndex = match.end;

        }



        if (lastIndex < text.length) {

          spanChildren.add(TextSpan(text: text.substring(lastIndex)));

        }



        widgets.add(Padding(

          padding: const EdgeInsets.only(bottom: 12.0, left: 16.0),

          child: Row(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Container(

                margin: const EdgeInsets.only(top: 8, right: 12),

                width: 6,

                height: 6,

                decoration: BoxDecoration(

                  color: theme.primaryColor,

                  shape: BoxShape.circle,

                ),

              ),

              Expanded(

                child: RichText(

                  text: TextSpan(

                    style: TextStyle(

                      fontSize: 15,

                      height: 1.6,

                      color: onSurface.withValues(alpha: 0.8),

                      fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,

                    ),

                    children: spanChildren,

                  ),

                ),

              ),

            ],

          ),

        ));

      } else {

        widgets.add(Text(

          line,

          style: TextStyle(

            fontSize: 15,

            height: 1.6,

            color: onSurface.withValues(alpha: 0.8),

          ),

        ));

      }

    }

    return widgets;

  }



  @override

  Widget build(BuildContext context) {

    final onSurface = AppColors.getOnSurface(context);

    

    return Scaffold(

      backgroundColor: AppColors.getSurface(context),

      resizeToAvoidBottomInset: false,

      appBar: AppBar(

        backgroundColor: Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: Text(

          theme.title.toUpperCase(),

          style: TextStyle(

            fontSize: 14,

            fontWeight: FontWeight.w900,

            letterSpacing: 2,

            color: onSurface,

          ),

        ),

        leading: IconButton(

          icon: Icon(Icons.arrow_back_ios_new_rounded, color: onSurface, size: 18),

          onPressed: () => Navigator.of(context).pop(),

        ),

      ),

      body: ResponsiveLayout(

        showParticles: false,

        useSafeArea: true,

        child: SingleChildScrollView(

          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [

              GlassCard(

                child: Padding(

                  padding: const EdgeInsets.all(32),

                  child: Column(

                  children: [

                    Icon(theme.icon, size: 60, color: theme.primaryColor),

                    const SizedBox(height: 24),

                    Text(

                      theme.title,

                      textAlign: TextAlign.center,

                      style: TextStyle(

                        fontSize: 28,

                        fontWeight: FontWeight.w900,

                        color: onSurface,

                        height: 1.2,

                      ),

                    ),

                    const SizedBox(height: 8),

                    Text(

                      theme.subtitle,

                      textAlign: TextAlign.center,

                      style: TextStyle(

                        fontSize: 16,

                        color: onSurface.withValues(alpha: 0.7),

                        fontWeight: FontWeight.w500,

                      ),

                    ),

                  ],

                ),

                ),

              ),

              const SizedBox(height: 32),

              ..._buildRichContent(context, theme.contentMarkdown),

              const SizedBox(height: 60),

            ],

          ),

        ),

      ),

    );

  }

}

