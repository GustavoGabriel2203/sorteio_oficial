import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:sorteio_oficial/features/participants/presentation/cubit/participants_cubit.dart';
import 'package:sorteio_oficial/features/participants/presentation/cubit/participants_state.dart';

class ParticipantsPage extends StatefulWidget {
  const ParticipantsPage({super.key});

  @override
  State<ParticipantsPage> createState() => _ParticipantsPageState();
}

class _ParticipantsPageState extends State<ParticipantsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ParticipantCubit>().fetchParticipants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(
          'Participantes',
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[400],
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<ParticipantCubit, ParticipantState>(
        builder: (context, state) {
          if (state is ParticipantLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          } else if (state is ParticipantLoaded) {
            final list = state.participants;

            if (list.isEmpty) {
              return Center(
                child: Text(
                  'Nenhum participante encontrado.',
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: list.length,
              separatorBuilder: (_, __) => SizedBox(height: 14.h),
              itemBuilder: (context, index) {
                final participant = list[index];

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.green.shade300, width: 1.2.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green,
                        blurRadius: 6.r,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        participant.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[300],
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        participant.phone,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        participant.email,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is ParticipantError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Colors.redAccent, fontSize: 16.sp),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
