import 'package:chronicling_america_api/providers/audio_service.dart';
import 'package:chronicling_america_api/providers/home_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Chronicling America'), centerTitle: true),
        body: Consumer<HomeProvider>(
            builder: (context, value, child) => RefreshIndicator(
                // RefreshIndicator to support pull-to-refresh functionality
                onRefresh: () async => await value.fetchData(query: 'oakland', isLoadMore: false),
                child: Column(children: [
                  Expanded(
                      // Use Expanded to fill the available space in the column
                      child: value.isLoading && value.currentPage == 1
                          // Display loading indicator if data is being fetched for the first page
                          ? const Center(child: CupertinoActivityIndicator())
                          : ListView.builder(
                              // ListView.builder for displaying a scrollable list of items
                              shrinkWrap: true, // Allows the ListView to take only the space needed
                              itemCount: value.apiResponse?.items?.length ?? 0,
                              controller: value.scrollController,
                              itemBuilder: (context, index) {
                                final item = value.apiResponse?.items?[index];
                                return ListTile(
                                    // Display each item in the ListView
                                    title: Text(item?.title ?? 'No Title',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    subtitle: Text(item?.publisher ?? 'No Publisher',
                                        style: const TextStyle(fontSize: 14)),
                                    trailing: Consumer<AudioService>(
                                        // Consumer for AudioService to manage audio playback
                                        builder: (context, audioService, child) {
                                      // Check if the current item is being played
                                      bool isCurrentItem = audioService.currentPlayingItemId == item?.id;
                                      return IconButton(
                                          icon: Icon(
                                            isCurrentItem && audioService.isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                          ),
                                          onPressed: () {
                                            if (audioService.isPlaying) {
                                              audioService.pause();
                                            } else {
                                              // Start speaking the item text
                                              audioService.speak(
                                                  "title is ${item!.title} and Publisher is ${item.publisher}",
                                                  item.id ?? '');
                                            }
                                          });
                                    }));
                              })),
                  if (value.hasMoreData)
                    if (value.isLoadingMore)
                      // Display loading indicator for additional data when loading more
                      const Padding(
                          padding: EdgeInsets.all(8.0), child: Center(child: CupertinoActivityIndicator())),
                  if (value.errorMessage.isNotEmpty)
                    // Display error message and retry button if an error occurred
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Text('Error: ${value.errorMessage}', textAlign: TextAlign.center),
                              TextButton(
                                  onPressed: () => value.fetchData(query: 'oakland', isLoadMore: false),
                                  child: const Text('Retry'))
                            ])))
                ]))));
  }
}
