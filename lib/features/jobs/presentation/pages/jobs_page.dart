import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/job_model.dart';
import '../../data/services/job_service.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final JobService _service = JobService();

  final TextEditingController searchController =
      TextEditingController();

  List<JobModel> jobs = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  Future<void> loadJobs() async {
    final data = await _service.getJobs();

    if (!mounted) return;

    setState(() {
      jobs = data;
      loading = false;
    });
  }

  Future<void> search(String text) async {
    final data = await _service.searchJobs(text);

    if (!mounted) return;

    setState(() {
      jobs = data;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5FC),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("الوظائف"),
        // زر الرجوع المضاف حديثاً
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadJobs,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    controller: searchController,
                    onChanged: search,
                    decoration: InputDecoration(
                      hintText: "ابحثي عن وظيفة أو شركة أو محافظة...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "عدد الوظائف: ${jobs.length}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (jobs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(
                        child: Text(
                          "لا توجد نتائج",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),

                  ...jobs.map(
                    (job) => Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.deepPurple.shade100,
                          child: const Icon(
                            Icons.business,
                            color: Colors.deepPurple,
                          ),
                        ),
                        title: Text(
                          job.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "${job.company}\n📍 ${job.city}",
                          ),
                        ),
                        isThreeLine: true,
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          context.push('/job/${job.id}');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}