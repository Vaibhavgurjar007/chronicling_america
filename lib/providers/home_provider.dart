import 'package:chronicling_america_api/utils/api_urls.dart';
import 'package:flutter/material.dart';

import '../models/api_response_model.dart';
import '../services/api_service.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider() {
    // Fetch initial data for the 'oakland' query when the provider is created
    fetchData(query: 'oakland');

    // Add a listener to the scroll controller to trigger data fetching when reaching the bottom
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        // Fetch more data when scrolled to the bottom
        fetchData(query: 'oakland', isLoadMore: true);
      }
    });
  }

  // Controller for handling scroll events
  final ScrollController scrollController = ScrollController();
  // Service for making API requests
  final ApiService _apiService = ApiService();

  // Holds the API response data
  ApiResponse? _apiResponse;
  // Holds error messages, if any
  String _errorMessage = '';
  // Flags for tracking loading states
  bool _isLoading = false;
  bool _isLoadingMore = false;
  // Flags for tracking data availability
  bool _hasMoreData = true;
  // Current page number for pagination
  int _currentPage = 1;
  // Number of items to fetch per page
  final int _itemsPerPage = 10;

  // Public getters for accessing private variables
  ApiResponse? get apiResponse => _apiResponse;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  int get currentPage => _currentPage;
  bool get hasMoreData => _hasMoreData;

  Future<void> fetchData({required String query, bool isLoadMore = false}) async {
    // Prevent concurrent requests
    if (isLoading || isLoadingMore) return;

    if (!isLoadMore) {
      // Reset state for initial data fetch
      _resetState();
    } else {
      if (!hasMoreData) return; // No more data to load
      _startLoadingMore();
    }

    try {
      // Fetch data from the API
      final response = await _apiService.fetchData(
        query: query,
        page: _currentPage,
        url: ApiUrls.ALL_DATA_URL,
      );
      // Handle the API response
      _handleResponse(response, isLoadMore);
      // Clear any previous error messages
      _errorMessage = '';
    } catch (e) {
      // Set error message if an exception occurs
      _errorMessage = e.toString();
    } finally {
      // Finalize loading states and notify listeners
      _finalizeLoading();
      notifyListeners();
    }
  }

  // Reset state for the initial data fetch
  void _resetState() {
    _isLoading = true;
    _currentPage = 1;
    _apiResponse = null;
    _hasMoreData = true;
    notifyListeners();
  }

  // Start the loading process for fetching more data
  void _startLoadingMore() {
    _isLoadingMore = true;
    notifyListeners();
  }

  // Handle the API response, either updating or appending data
  void _handleResponse(ApiResponse response, bool isLoadMore) {
    _currentPage++;
    _hasMoreData = response.items != null && response.items!.length >= _itemsPerPage;

    if (isLoadMore) {
      // Append new data to existing data
      if (_apiResponse?.items != null) {
        _apiResponse!.items!.addAll(response.items!);
      } else {
        _apiResponse = response;
      }
    } else {
      // Replace the existing data with new data
      _apiResponse = response;
    }
  }

  // Finalize the loading states after data fetching
  void _finalizeLoading() {
    _isLoading = false;
    _isLoadingMore = false;
  }
}
