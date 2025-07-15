import 'package:flutter/material.dart';
import 'package:jasara_poc/widgets/utils/app_text_field.dart';
import 'package:provider/provider.dart';

import '../providers/add_rfi_provider.dart';
import 'utils/app_drop_down.dart';

class TextFieldsEarlier {
  static List<Widget> getFields(BuildContext context) {
    final provider = Provider.of<HomePageProvider>(context, listen: false);
    List<Widget> oldFields = [
      AppTextField(
        label: "Opportunity Code",
        controller: provider.controllers['opportunityCode']!,
      ),
      AppTextField(
        label: "Opportunity Name",
        controller: provider.controllers['opportunityName']!,
      ),
      AppTextField(label: "Date", controller: provider.controllers['date']!),
      AppTextField(
        label: "Proposal Manager",
        controller: provider.controllers['proposalManager']!,
      ),
      AppTextField(
        label: "Brief Description of Work",
        controller: provider.controllers['description']!,
      ),
      AppDropdown(
        label: "Project Type",
        dropdownKey: 'projectType',
        items: ['Internal', 'Client-Based', 'R&D'],
        controller: provider.controllers['projectType']!,
        onChanged:
            (value) => provider.controllers['projectType']!.text = value!,
      ),
      AppTextField(
        label: "Client Name",
        controller: provider.controllers['clientName']!,
      ),
      AppDropdown(
        label: "Client Type",
        dropdownKey: 'clientType',
        items: ['Government', 'Private', 'NGO'],
        controller: provider.controllers['clientType']!,
        onChanged: (value) => provider.controllers['clientType']!.text = value!,
      ),
      AppDropdown(
        label: "Relationship with Client",
        dropdownKey: 'relationship',
        items: ['Excellent', 'Good', 'Neutral', 'Poor'],
        controller: provider.controllers['relationship']!,
        onChanged:
            (value) => provider.controllers['relationship']!.text = value!,
      ),
      AppTextField(
        label: "Submission Date",
        controller: provider.controllers['submissionDate']!,
      ),
      AppTextField(
        label: "Bidding Criteria",
        controller: provider.controllers['biddingCriteria']!,
      ),
      AppDropdown(
        label: "Is it a targeted project?",
        dropdownKey: 'isTargeted',
        items: ['Yes', 'No'],
        controller: provider.controllers['isTargeted']!,
        onChanged: (value) => provider.controllers['isTargeted']!.text = value!,
      ),
      AppTextField(
        label: "Comments",
        controller: provider.controllers['comments']!,
      ),
    ];
    return oldFields;
  }
}
