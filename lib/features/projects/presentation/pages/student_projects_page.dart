import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:vitapmate/core/providers/settings.dart';
import 'package:vitapmate/features/more/presentation/widgets/more_color.dart';
import 'package:vitapmate/features/projects/presentation/providers/student_projects_provider.dart';

class StudentProjectsPage extends HookConsumerWidget {
  const StudentProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(studentProjectsProvider);

    Future<void> refresh() async {
      await ref.read(studentProjectsProvider.notifier).refresh();
    }

    return RefreshIndicator(
      onRefresh: refresh,
      backgroundColor: context.theme.colors.primary,
      color: context.theme.colors.primaryForeground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 20),
        child: projectsAsync.when(
          data: (payload) => _projectsContent(payload: payload),
          error: (_, _) => _projectsContent(
            payload: defaultStudentProjectsPayload,
            warning: 'Could not refresh projects. Showing saved defaults.',
          ),
          loading: () => _projectsContent(
            payload: defaultStudentProjectsPayload,
            isLoading: true,
          ),
        ),
      ),
    );
  }

  Widget _projectsContent({
    required StudentProjectsPayload payload,
    bool isLoading = false,
    String? warning,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        final colors = context.theme.colors;
        final pinnedIds = ref.watch(studentProjectPinnedIdsProvider);
        final pinnedOnly = ref.watch(studentProjectsPinnedOnlySessionProvider);
        final controller = ref.read(studentProjectsSettingsControllerProvider);
        final visibleProjects = pinnedOnly
            ? payload.projects
                  .where((project) => pinnedIds.contains(project.id))
                  .toList()
            : payload.projects;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Projects by other students',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                FButton(
                  size: FButtonSizeVariant.sm,
                  variant: pinnedOnly
                      ? FButtonVariant.primary
                      : FButtonVariant.outline,
                  onPress: () {
                    ref
                        .read(studentProjectsPinnedOnlySessionProvider.notifier)
                        .toggle();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        pinnedOnly ? Icons.push_pin : Icons.push_pin_outlined,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(pinnedOnly ? 'Pinned only' : 'All projects'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Projects rotate every time you open the app.',
              style: TextStyle(color: MoreColors.secondaryText),
            ),
            if (isLoading) ...[
              const SizedBox(height: 10),
              LinearProgressIndicator(
                minHeight: 3,
                color: colors.primary,
                backgroundColor: colors.primary.withValues(alpha: .14),
                borderRadius: BorderRadius.circular(8),
              ),
            ],
            if (warning != null) ...[
              const SizedBox(height: 10),
              Text(
                warning,
                style: TextStyle(
                  color: MoreColors.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (visibleProjects.isEmpty)
              _emptyState(context)
            else
              FTabs(
                scrollable: true,
                children: [
                  for (final category in payload.categories)
                    FTabEntry(
                      label: Text(
                        '${category.label} (${_countProjects(visibleProjects, category.id)})',
                      ),
                      child: _categoryTab(
                        context: context,
                        category: category,
                        projects: visibleProjects
                            .where((project) => project.category == category.id)
                            .toList(),
                        pinnedIds: pinnedIds,
                        controller: controller,
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 12),
            FTappable(
              onPress: () async {
                await launchUrl(
                  Uri.parse(payload.cta.url),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: Text(
                payload.cta.label,
                style: TextStyle(
                  color: colors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _categoryTab({
    required BuildContext context,
    required StudentProjectCategory category,
    required List<StudentProject> projects,
    required Set<int> pinnedIds,
    required StudentProjectsSettingsController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (category.description.isNotEmpty) ...[
          Text(
            category.description,
            style: TextStyle(color: MoreColors.secondaryText, fontSize: 13),
          ),
          const SizedBox(height: 12),
        ],
        if (projects.isEmpty)
          _emptyState(context)
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = width >= 900 ? 3 : (width >= 620 ? 2 : 1);
              const gap = 12.0;
              final cardWidth = (width - (gap * (columns - 1))) / columns;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final project in projects)
                    SizedBox(
                      width: cardWidth,
                      child: _ProjectCard(
                        key: ValueKey(project.id),
                        project: project,
                        category: category,
                        isPinned: pinnedIds.contains(project.id),
                        onTogglePinned: () =>
                            controller.togglePinned(project.id),
                        onOpen: () async {
                          await _confirmAndLaunchUrl(
                            context,
                            url: Uri.parse(project.url),
                            title: 'Open student project',
                            body: 'You are going to a student-built project.',
                          );
                        },
                        onOpenSource: project.sourceUrl == null
                            ? null
                            : () async {
                                await _confirmAndLaunchUrl(
                                  context,
                                  url: Uri.parse(project.sourceUrl!),
                                  title: 'Open source link',
                                  body:
                                      'You are going to a student project source link.',
                                );
                              },
                      ),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }

  Widget _emptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.theme.colors.secondary.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.theme.colors.border),
      ),
      child: const Text('Pin projects to build your shortlist.'),
    );
  }

  int _countProjects(List<StudentProject> projects, String categoryId) {
    return projects.where((project) => project.category == categoryId).length;
  }

  Future<void> _confirmAndLaunchUrl(
    BuildContext context, {
    required Uri url,
    required String title,
    required String body,
  }) async {
    final shouldOpen = await showFDialog<bool>(
      context: context,
      builder: (context, style, animation) => FDialog(
        animation: animation,
        direction: Axis.horizontal,
        title: Text(title),
        body: Text(body),
        actions: [
          FButton(
            variant: FButtonVariant.outline,
            onPress: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FButton(
            onPress: () => Navigator.of(context).pop(true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (shouldOpen == true) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

class _ProjectCard extends StatelessWidget {
  final StudentProject project;
  final StudentProjectCategory category;
  final bool isPinned;
  final VoidCallback onTogglePinned;
  final VoidCallback onOpen;
  final VoidCallback? onOpenSource;

  const _ProjectCard({
    super.key,
    required this.project,
    required this.category,
    required this.isPinned,
    required this.onTogglePinned,
    required this.onOpen,
    required this.onOpenSource,
  });

  @override
  Widget build(BuildContext context) {
    return FCard(
      image: _ProjectPreview(key: ValueKey(project.id), project: project),
      title: Row(
        children: [
          Expanded(
            child: Text(
              project.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: isPinned ? 'Unpin project' : 'Pin project',
            onPressed: onTogglePinned,
            icon: Icon(
              isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              size: 20,
            ),
          ),
        ],
      ),
      subtitle: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          _BadgeText(project.type),
          _BadgeText(category.label),
          _BadgeText(
            project.sourceUrl == null ? 'Closed source' : 'Open source',
          ),
          for (final tag in project.tags.take(2)) _BadgeText(tag),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.summary, maxLines: 3, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Text(
            'By ${project.madeBy}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: MoreColors.secondaryText, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FButton(onPress: onOpen, child: const Text('Open')),
              ),
              if (onOpenSource != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FButton.icon(
                    variant: FButtonVariant.outline,
                    onPress: onOpenSource,
                    child: const Icon(Icons.code, size: 16),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BadgeText extends StatelessWidget {
  final String label;
  const _BadgeText(this.label);

  @override
  Widget build(BuildContext context) {
    return FBadge(
      variant: FBadgeVariant.secondary,
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }
}

class _ProjectPreview extends StatefulWidget {
  final StudentProject project;
  const _ProjectPreview({super.key, required this.project});

  @override
  State<_ProjectPreview> createState() => _ProjectPreviewState();
}

class _ProjectPreviewState extends State<_ProjectPreview> {
  static final _memoryPreviewUrls = <int, String>{};
  static final _previewUrlLoads = <int, Future<String?>>{};

  String? _imageUrl;
  int _loadVersion = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _ProjectPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.project.id != widget.project.id ||
        oldWidget.project.previewImage != widget.project.previewImage ||
        oldWidget.project.url != widget.project.url) {
      _imageUrl = null;
      _load();
    }
  }

  Future<void> _load() async {
    final version = ++_loadVersion;
    final projectId = widget.project.id;
    final projectUrl = widget.project.url;
    final directImageUrl = widget.project.previewImage;
    final cachedPreviewUrl = directImageUrl ?? _memoryPreviewUrls[projectId];
    if (cachedPreviewUrl != null) {
      _setImageUrl(cachedPreviewUrl, version);
      return;
    }

    final discoveredPreviewUrl = await _previewUrlLoads.putIfAbsent(
      projectId,
      () => _fetchPreviewImageUrl(projectUrl),
    );
    _previewUrlLoads.remove(projectId);
    if (!mounted ||
        version != _loadVersion ||
        projectId != widget.project.id ||
        projectUrl != widget.project.url ||
        discoveredPreviewUrl == null) {
      return;
    }
    _memoryPreviewUrls[projectId] = discoveredPreviewUrl;
    _setImageUrl(discoveredPreviewUrl, version);
  }

  void _setImageUrl(String imageUrl, int version) {
    if (_imageUrl != imageUrl && mounted && version == _loadVersion) {
      setState(() => _imageUrl = imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeOut,
            child: _previewChild(),
          ),
        ),
      ),
    );
  }

  Widget _previewChild() {
    if (_imageUrl != null) {
      return CachedNetworkImage(
        key: ValueKey('${widget.project.id}|$_imageUrl'),
        imageUrl: _imageUrl!,
        cacheKey: _cacheKeyFor(widget.project.id, _imageUrl!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.low,
        fadeInDuration: const Duration(milliseconds: 120),
        fadeOutDuration: const Duration(milliseconds: 80),
        placeholder: (_, _) => const _PreviewFallback(),
        errorWidget: (_, _, _) => const _PreviewFallback(),
      );
    }

    return const _PreviewFallback();
  }

  Future<String?> _fetchPreviewImageUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await http
          .get(uri, headers: {'User-Agent': 'vitapmate/1.0'})
          .timeout(const Duration(seconds: 6));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final html = response.body;
      String? extract(String attribute, String value, String target) {
        final forward = RegExp(
          '<meta[^>]+$attribute=["\\\']$value["\\\'][^>]+$target=["\\\']([^"\\\']+)["\\\']',
          caseSensitive: false,
        );
        final reverse = RegExp(
          '<meta[^>]+$target=["\\\']([^"\\\']+)["\\\'][^>]+$attribute=["\\\']$value["\\\']',
          caseSensitive: false,
        );
        return forward.firstMatch(html)?.group(1) ??
            reverse.firstMatch(html)?.group(1);
      }

      final raw =
          extract('property', 'og:image', 'content') ??
          extract('name', 'twitter:image', 'content');
      if (raw == null || raw.isEmpty) return null;

      final parsed = Uri.tryParse(raw.trim());
      if (parsed == null) return null;
      return parsed.hasScheme
          ? parsed.toString()
          : uri.resolveUri(parsed).toString();
    } catch (_) {
      return null;
    }
  }

  String _cacheKeyFor(int projectId, String imageUrl) {
    var hash = 0x811c9dc5;
    for (final unit in imageUrl.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return 'student-project-preview-$projectId-$hash';
  }
}

class _PreviewFallback extends StatelessWidget {
  const _PreviewFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0E7490), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 40),
      ),
    );
  }
}
